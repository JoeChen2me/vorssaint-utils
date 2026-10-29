// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import Carbon.HIToolbox
import Combine

/// Holds the input source the user chose for the frontmost app.
///
/// The rules run on the same app-activation notification the rest of the app
/// already listens to, plus a timer the user controls. Nothing polls while the
/// feature is off, and no Accessibility or Input Monitoring grant is involved:
/// the Text Input Sources services are available to any app. A source the user
/// disables, or a rule pointing at one, is skipped rather than fought over.
final class InputSourceLockService: ObservableObject {
    static let shared = InputSourceLockService()

    enum PauseReason: Equatable {
        case secureInput
    }

    @Published private(set) var isRunning = false
    @Published private(set) var pauseReason: PauseReason?

    private struct Configuration {
        var enabled: Bool
        var globalSourceID: String
        var rules: [String: String]
        var guardInterval: TimeInterval
        var showSwitchNotice: Bool
    }

    private var configuration = Configuration(
        enabled: false,
        globalSourceID: "",
        rules: [:],
        guardInterval: TimeInterval(Defaults.defaultInputSourceLockGuardIntervalSeconds),
        showSwitchNotice: false)
    private var workspaceObservers: [NSObjectProtocol] = []
    private var distributedObservers: [NSObjectProtocol] = []
    private var timer: Timer?
    private var pendingCheck: DispatchWorkItem?
    private var isSelecting = false
    /// The enabled sources change rarely. Reading the TIS list on every tick
    /// would pay for a full enumeration even while the source already matches;
    /// the notification invalidates this cache when System Settings changes.
    private var cachedEnabledSourceIDs: Set<String>?
    /// A source that refuses to be selected must not be retried every tick:
    /// each attempt can interrupt the app's current composition.
    private var consecutiveFailures = 0
    private var retryAfterUptime: TimeInterval = 0
    /// Secure Event Input owns the source for a password field. Its first
    /// tick after release is skipped so a choice made during the prompt is not
    /// taken back immediately.
    private var secureInputWasEnabled = false
    /// A source the system accepted but did not land. It is checked again on
    /// the next turn instead of being selected over and over.
    private var lastSelection: (target: String, previous: String?, at: TimeInterval)?

    private init() {
        SessionActivity.shared.onChange { [weak self] _ in self?.syncWithPreferences() }
    }

    func syncWithPreferences() {
        onMain { [weak self] in self?.applyPreferences() }
    }

    private func applyPreferences() {
        let defaults = UserDefaults.standard
        let next = Configuration(
            enabled: AppFeature.inputSourceLock.isAvailable
                && defaults.bool(forKey: DefaultsKey.inputSourceLockEnabled),
            globalSourceID: defaults.string(forKey: DefaultsKey.inputSourceLockGlobalSourceID) ?? "",
            rules: InputSourceLockSupport.sanitizedRules(
                defaults.dictionary(forKey: DefaultsKey.inputSourceLockRules)),
            guardInterval: TimeInterval(Defaults.sanitizedInputSourceLockGuardInterval(
                defaults.integer(forKey: DefaultsKey.inputSourceLockGuardIntervalSeconds))),
            showSwitchNotice: defaults.bool(forKey: DefaultsKey.inputSourceLockShowSwitchNotice)
        )
        configuration = next
        cachedEnabledSourceIDs = nil
        consecutiveFailures = 0
        retryAfterUptime = 0
        lastSelection = nil

        let shouldRun = next.enabled
            && SessionActivity.shared.isActive
            && InputSourceLockSupport.hasConfiguredTarget(globalSourceID: next.globalSourceID,
                                                          rules: next.rules)
        guard shouldRun else {
            stop()
            return
        }
        if isRunning {
            restartTimer()
            correctFrontmostApp()
        } else {
            start()
        }
    }

    private func start() {
        guard !isRunning else { return }
        let center = NSWorkspace.shared.notificationCenter
        workspaceObservers = [
            center.addObserver(forName: NSWorkspace.didActivateApplicationNotification,
                               object: nil, queue: .main) { [weak self] _ in
                self?.scheduleActivationCheck()
            },
            center.addObserver(forName: NSWorkspace.didWakeNotification,
                               object: nil, queue: .main) { [weak self] _ in
                self?.wake()
            },
            center.addObserver(forName: NSWorkspace.screensDidWakeNotification,
                               object: nil, queue: .main) { [weak self] _ in
                self?.wake()
            },
            center.addObserver(forName: NSWorkspace.willSleepNotification,
                               object: nil, queue: .main) { [weak self] _ in
                self?.suspendTimer()
            },
            center.addObserver(forName: NSWorkspace.screensDidSleepNotification,
                               object: nil, queue: .main) { [weak self] _ in
                self?.suspendTimer()
            },
        ]
        distributedObservers = [
            DistributedNotificationCenter.default().addObserver(
                forName: NSNotification.Name(kTISNotifyEnabledKeyboardInputSourcesChanged as String),
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.enabledSourcesDidChange()
                },
        ]
        cachedEnabledSourceIDs = nil
        consecutiveFailures = 0
        retryAfterUptime = 0
        secureInputWasEnabled = false
        isRunning = true
        restartTimer()
        correctFrontmostApp()
    }

    private func stop() {
        for observer in workspaceObservers {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
        workspaceObservers.removeAll()
        for observer in distributedObservers {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
        distributedObservers.removeAll()
        timer?.invalidate()
        timer = nil
        pendingCheck?.cancel()
        pendingCheck = nil
        secureInputWasEnabled = false
        lastSelection = nil
        pauseReason = nil
        if isRunning { isRunning = false }
    }

    private func suspendTimer() {
        timer?.invalidate()
        timer = nil
        pendingCheck?.cancel()
        pendingCheck = nil
    }

    private func restartTimer() {
        timer?.invalidate()
        let interval = max(configuration.guardInterval, 1)
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.correctFrontmostApp()
        }
        timer.tolerance = min(1, interval * 0.2)
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func wake() {
        guard isRunning else { return }
        cachedEnabledSourceIDs = nil
        retryAfterUptime = 0
        lastSelection = nil
        pauseReason = nil
        restartTimer()
        correctFrontmostApp()
    }

    /// The window server may switch a document's source just after the app
    /// comes forward, so the immediate correction waits one run loop turn
    /// longer than activation. The timer covers a switch that lands later.
    private func scheduleActivationCheck() {
        guard isRunning else { return }
        cachedEnabledSourceIDs = nil
        retryAfterUptime = 0
        lastSelection = nil
        pendingCheck?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.pendingCheck = nil
            self.correctFrontmostApp()
        }
        pendingCheck = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12, execute: work)
    }

    private func enabledSourcesDidChange() {
        cachedEnabledSourceIDs = nil
        correctFrontmostApp()
    }

    private func enabledSourceIDs() -> Set<String> {
        if let cachedEnabledSourceIDs { return cachedEnabledSourceIDs }
        let ids = Set(InputSourceSelection.selectableSources().map(\.id))
        cachedEnabledSourceIDs = ids
        return ids
    }

    private func correctFrontmostApp() {
        guard isRunning, configuration.enabled, !isSelecting else { return }
        // A password field owns the source while Secure Event Input is on:
        // forcing the locked source there would fight the system's own ASCII
        // switch. The first tick after the field closes is skipped too, so a
        // source the person chose during the prompt is not taken back at once.
        if IsSecureEventInputEnabled() {
            secureInputWasEnabled = true
            if pauseReason != .secureInput { pauseReason = .secureInput }
            return
        }
        if secureInputWasEnabled {
            secureInputWasEnabled = false
            pauseReason = nil
            return
        }
        if pauseReason != nil { pauseReason = nil }
        // The Command Bar borrows an ASCII layout while its non-activating
        // panel is open, so the frontmost app is still its target app and the
        // lock has to wait rather than take the borrowed layout back. The
        // panel's visibility, not a restoration record that can outlive a
        // failed restore, decides when the pause ends.
        if AppFeature.commandBar.isAvailable, CommandBarService.shared.isVisible {
            return
        }
        let now = ProcessInfo.processInfo.systemUptime
        guard now >= retryAfterUptime else { return }
        guard let app = NSWorkspace.shared.frontmostApplication,
              let bundleID = app.bundleIdentifier else { return }
        let currentSourceID = InputSourceSelection.currentSourceID()
        guard let candidate = InputSourceLockSupport.candidateSourceID(
            frontmostBundleID: bundleID,
            ownBundleID: Bundle.main.bundleIdentifier,
            globalSourceID: configuration.globalSourceID,
            rules: configuration.rules),
              InputSourceLockSupport.needsCorrection(
                currentSourceID: currentSourceID,
                targetSourceID: candidate)
        else {
            // The source matches, so any accepted switch did land.
            lastSelection = nil
            return
        }
        // A switch the system accepted but did not land is not selected again
        // on the next instant: give TIS a moment, then count it as a failure
        // and back off instead of flickering the app's own source every tick.
        // A third source means a person changed it, so the ordinary correction
        // continues without a backoff.
        if let lastSelection, lastSelection.target == candidate {
            if currentSourceID == lastSelection.previous {
                guard now - lastSelection.at >= 1.5 else { return }
                self.lastSelection = nil
                recordFailure(now: now)
                return
            }
            self.lastSelection = nil
        }
        guard let target = InputSourceLockSupport.targetSourceID(
            frontmostBundleID: bundleID,
            ownBundleID: Bundle.main.bundleIdentifier,
            globalSourceID: configuration.globalSourceID,
            rules: configuration.rules,
            enabledSourceIDs: enabledSourceIDs())
        else { return }

        isSelecting = true
        let selected = InputSourceSelection.select(sourceID: target)
        isSelecting = false
        guard selected else {
            recordFailure(now: now)
            return
        }
        consecutiveFailures = 0
        retryAfterUptime = 0
        lastSelection = (target, currentSourceID, now)
        // A correction is the app's own switch, not a typist's. Marking it
        // keeps the island quiet by default; the preference lets a person ask
        // for the confirmation instead.
        if AppFeature.notch.isAvailable, !configuration.showSwitchNotice {
            NotchService.shared.noteOwnInputSourceSwitch(to: target)
        }
    }

    private func recordFailure(now: TimeInterval) {
        consecutiveFailures = min(consecutiveFailures + 1, 6)
        let exponent = max(0, min(consecutiveFailures - 1, 6))
        retryAfterUptime = now + min(60, Double(1 << exponent))
    }

    private func onMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
