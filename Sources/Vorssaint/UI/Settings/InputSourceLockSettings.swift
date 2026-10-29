// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import Combine
import SwiftUI

/// Settings for the input source lock: one global source first, the per-app
/// overrides folded away below it, then the interval its guard checks at.
struct InputSourceLockSettings: View {
    @ObservedObject private var l10n = L10n.shared
    @ObservedObject private var lock = InputSourceLockService.shared
    @AppStorage(DefaultsKey.inputSourceLockEnabled) private var enabled = false
    @AppStorage(DefaultsKey.inputSourceLockGlobalSourceID) private var globalSourceID = ""
    @AppStorage(DefaultsKey.inputSourceLockGuardIntervalSeconds) private var guardInterval =
        Defaults.defaultInputSourceLockGuardIntervalSeconds
    @AppStorage(DefaultsKey.inputSourceLockShowSwitchNotice) private var showSwitchNotice = false
    @State private var sources: [InputSourceSelection.SelectableSource] = []
    @State private var rules: [String: String] = Self.savedRules
    @State private var rulesExpanded = false
    @State private var showingAppPicker = false

    private var strings: InputSourceLockStrings {
        FeatureStrings.inputSourceLock(l10n.language)
    }

    private var sourceIDs: Set<String> {
        Set(sources.map(\.id))
    }

    private var sortedRuleBundleIDs: [String] {
        rules.keys.sorted {
            let byName = InstalledApps.name(for: $0)
                .localizedCaseInsensitiveCompare(InstalledApps.name(for: $1))
            return byName == .orderedSame ? $0 < $1 : byName == .orderedAscending
        }
    }

    var body: some View {
        Form {
            globalSection
            perAppSection
            guardSection
            if sources.isEmpty {
                noSourcesSection
            }
        }
        .formStyle(.grouped)
        .onAppear {
            globalSourceID = globalSourceID.trimmingCharacters(in: .whitespacesAndNewlines)
            guardInterval = Defaults.sanitizedInputSourceLockGuardInterval(guardInterval)
            reloadSources()
            lock.syncWithPreferences()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: NSApplication.didBecomeActiveNotification)) { _ in
            reloadSources()
        }
        .sheet(isPresented: $showingAppPicker) {
            appPicker
        }
    }

    private var globalSection: some View {
        Section(strings.globalSection) {
            Toggle(strings.enable, isOn: $enabled)
                .onChange(of: enabled) { _, _ in
                    lock.syncWithPreferences()
                }
            Text(strings.enableCaption)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if enabled {
                if lock.pauseReason == .secureInput {
                    Label(strings.secureInputPaused, systemImage: "pause.circle")
                        .font(.caption)
                        .foregroundStyle(.orange)
                } else if lock.isRunning {
                    Label(strings.activeNow, systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            Picker(strings.globalSourceLabel, selection: $globalSourceID) {
                Text(strings.globalNone).tag("")
                ForEach(sources) { source in
                    Text(source.name).tag(source.id)
                }
                if !globalSourceID.isEmpty, !sourceIDs.contains(globalSourceID) {
                    Text("\(strings.sourceUnavailable) (\(globalSourceID))").tag(globalSourceID)
                }
            }
            .onChange(of: globalSourceID) { _, _ in
                lock.syncWithPreferences()
            }
            if !globalSourceID.isEmpty, !sourceIDs.contains(globalSourceID) {
                Label("\(strings.sourceUnavailable): \(globalSourceID)",
                      systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Text(strings.globalCaption)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var perAppSection: some View {
        Section {
            DisclosureGroup(isExpanded: $rulesExpanded) {
                if sortedRuleBundleIDs.isEmpty {
                    Text(strings.noApps)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                } else {
                    ForEach(sortedRuleBundleIDs, id: \.self) { bundleID in
                        ruleRow(bundleID)
                    }
                }
                Text(strings.perAppCaption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                HStack {
                    Text(strings.perAppSection)
                    Spacer()
                    if !rules.isEmpty {
                        Text("\(rules.count)")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }
            Button {
                showingAppPicker = true
            } label: {
                Label(strings.addApps, systemImage: "plus")
            }
            .controlSize(.small)
            .disabled(sources.isEmpty)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var guardSection: some View {
        Section(strings.guardSection) {
            Stepper(value: $guardInterval,
                    in: Defaults.allowedInputSourceLockGuardIntervalRange) {
                HStack {
                    Text(strings.guardInterval)
                    Spacer()
                    Text("\(guardInterval) s")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .onChange(of: guardInterval) { _, _ in
                lock.syncWithPreferences()
            }
            Toggle(strings.showSwitchNotice, isOn: $showSwitchNotice)
                .onChange(of: showSwitchNotice) { _, _ in
                    lock.syncWithPreferences()
                }
            Text(strings.guardCaption)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var noSourcesSection: some View {
        Section {
            Label(strings.noSources, systemImage: "exclamationmark.triangle")
                .font(.callout.weight(.semibold))
            Text(strings.noSourcesCaption)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Button(strings.openKeyboardSettings) {
                guard let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension")
                else { return }
                NSWorkspace.shared.open(url)
            }
        }
    }

    private func ruleRow(_ bundleID: String) -> some View {
        HStack(spacing: 9) {
            Image(nsImage: InstalledApps.icon(for: bundleID))
                .resizable()
                .frame(width: 18, height: 18)
            Text(InstalledApps.name(for: bundleID))
                .lineLimit(1)
            Spacer(minLength: 8)
            Picker(strings.globalSourceLabel, selection: binding(for: bundleID)) {
                Text(strings.globalNone).tag("")
                ForEach(sources) { source in
                    Text(source.name).tag(source.id)
                }
                if let stored = rules[bundleID], !stored.isEmpty, !sourceIDs.contains(stored) {
                    Text("\(strings.sourceUnavailable) (\(stored))").tag(stored)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(minWidth: 150)
            Button {
                remove(bundleID)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(strings.removeApp)
        }
    }

    /// New rows start on the global source when it is usable, so adding a
    /// group of apps does not ask the same question once per app. With no
    /// usable global source the row starts on "Don't change" and the person
    /// picks a source for each app; choosing the system's first source here
    /// would lock an app to a value nobody selected.
    private var preferredSourceForNewRule: String {
        InputSourceLockSupport.preferredSourceForNewRule(
            globalSourceID: globalSourceID,
            availableSourceIDs: sourceIDs)
    }

    private var appPicker: some View {
        InputSourceAppPickerView(
            title: strings.appPickerTitle,
            searchPlaceholder: strings.appPickerSearch,
            browseTitle: strings.appPickerBrowse,
            cancelTitle: strings.appPickerCancel,
            addTitle: strings.appPickerAdd,
            emptyText: strings.appPickerEmpty,
            selectedFormat: strings.appPickerSelectedFormat,
            excludedBundleIDs: Set(rules.keys),
            onCancel: { showingAppPicker = false },
            onAdd: { bundleIDs in
                showingAppPicker = false
                guard !bundleIDs.isEmpty else { return }
                var updated = rules
                let preferred = preferredSourceForNewRule
                for bundleID in bundleIDs where updated[bundleID] == nil {
                    updated[bundleID] = preferred
                }
                save(updated)
                rulesExpanded = true
            }
        )
    }

    private func binding(for bundleID: String) -> Binding<String> {
        Binding {
            rules[bundleID] ?? ""
        } set: { newValue in
            var updated = rules
            updated[bundleID] = newValue
            save(updated)
        }
    }

    private func remove(_ bundleID: String) {
        var updated = rules
        updated.removeValue(forKey: bundleID)
        save(updated)
    }

    private func save(_ updated: [String: String]) {
        let cleaned = InputSourceLockSupport.sanitizedRules(updated)
        UserDefaults.standard.set(cleaned, forKey: DefaultsKey.inputSourceLockRules)
        rules = cleaned
        lock.syncWithPreferences()
    }

    private func reloadSources() {
        sources = InputSourceSelection.selectableSources()
    }

    private static var savedRules: [String: String] {
        InputSourceLockSupport.sanitizedRules(
            UserDefaults.standard.dictionary(forKey: DefaultsKey.inputSourceLockRules))
    }
}
