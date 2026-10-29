// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

enum InputSourceLockTests {
    static func run(_ suite: TestSuite) {
        let us = "com.apple.keylayout.US"
        let pinyin = "com.apple.inputmethod.SCIM.ITABC"
        let russian = "com.apple.keylayout.Russian"
        let enabled: Set<String> = [us, pinyin]
        let ownBundleID = "com.vorssaint.app"

        func target(_ bundleID: String?,
                    global: String = "",
                    rules: [String: String] = [:]) -> String? {
            InputSourceLockSupport.targetSourceID(
                frontmostBundleID: bundleID,
                ownBundleID: ownBundleID,
                globalSourceID: global,
                rules: rules,
                enabledSourceIDs: enabled)
        }

        suite.expect(target("com.apple.Safari", global: us) == us,
               "an app without a rule keeps the global source")
        suite.expect(target("com.apple.Telegram", global: us, rules: ["com.apple.Telegram": pinyin]) == pinyin,
               "an app rule wins over the global source")
        suite.expect(target("com.apple.Telegram", global: "", rules: ["com.apple.Telegram": pinyin]) == pinyin,
               "app rules work without a global source, so only listed apps are locked")
        suite.expect(target("com.apple.Safari", global: "") == nil,
               "with no global source and no rule the app is left alone")
        suite.expect(target("com.apple.Terminal", global: us,
                            rules: ["com.apple.Terminal": russian]) == nil,
               "a rule pointing at a disabled source leaves that app alone instead of inheriting the global source")
        suite.expect(target("com.apple.Terminal", global: russian) == nil,
               "a disabled global source is never applied")
        suite.expect(target("com.apple.Terminal", global: us,
                            rules: ["com.apple.Terminal": "  "]) == nil,
               "an app set to no source stays alone")
        suite.expect(target("com.apple.Terminal", global: " \(us) ") == us,
               "stored source identifiers are trimmed before they are compared")
        suite.expect(target(ownBundleID, global: us) == nil,
               "Vorssaint's own panels never have their borrowed layout taken back")
        suite.expect(target(nil, global: us) == nil,
               "without a frontmost app there is nothing to lock")

        suite.expect(InputSourceLockSupport.candidateSourceID(
            frontmostBundleID: "com.apple.Terminal",
            ownBundleID: ownBundleID,
            globalSourceID: us,
            rules: ["com.apple.Terminal": russian]) == russian,
               "the candidate is resolved before the enabled-source listing, so an idle tick can skip it")
        suite.expect(InputSourceLockSupport.preferredSourceForNewRule(
            globalSourceID: "", availableSourceIDs: enabled).isEmpty,
               "a new app row starts on Don't change when there is no usable global source")
        suite.expect(InputSourceLockSupport.preferredSourceForNewRule(
            globalSourceID: us, availableSourceIDs: enabled) == us,
               "a new app row inherits the usable global source")
        suite.expect(InputSourceLockSupport.preferredSourceForNewRule(
            globalSourceID: russian, availableSourceIDs: enabled).isEmpty,
               "a disabled global source is not copied into a new app row")

        suite.expect(!InputSourceLockSupport.hasConfiguredTarget(globalSourceID: "", rules: [:]),
               "an empty setup has nothing to guard")
        suite.expect(InputSourceLockSupport.hasConfiguredTarget(globalSourceID: " ", rules: [:]) == false,
               "whitespace is not a configured global source")
        suite.expect(InputSourceLockSupport.hasConfiguredTarget(globalSourceID: "", rules: ["app": " "]) == false,
               "an app rule without a source is not a target")
        suite.expect(InputSourceLockSupport.hasConfiguredTarget(globalSourceID: "", rules: ["app": us]),
               "an app rule alone is enough to guard")

        suite.expect(!InputSourceLockSupport.needsCorrection(currentSourceID: us, targetSourceID: us),
               "the guard leaves a source that already matches")
        suite.expect(InputSourceLockSupport.needsCorrection(currentSourceID: russian, targetSourceID: us),
               "a different source is corrected")
        suite.expect(InputSourceLockSupport.needsCorrection(currentSourceID: nil, targetSourceID: us),
               "a source the system cannot read yet still gets a correction attempt")
        suite.expect(!InputSourceLockSupport.needsCorrection(currentSourceID: us, targetSourceID: nil),
               "no target means no correction")
        suite.expect(!InputSourceLockSupport.needsCorrection(currentSourceID: us, targetSourceID: " "),
               "a blank target means no correction")

        let stored: [String: Any] = [
            " com.apple.Terminal ": us,
            "com.apple.Telegram": pinyin,
            "": us,
            "com.apple.Number": 3,
            "com.apple.Off": "  ",
        ]
        let rules = InputSourceLockSupport.sanitizedRules(stored)
        suite.expect(rules["com.apple.Terminal"] == us && rules["com.apple.Telegram"] == pinyin,
               "stored app rules keep their source and trim the bundle identifier")
        suite.expect(rules["com.apple.Number"] == nil && rules[""] == nil,
               "stored app rules drop entries no app or source can match")
        suite.expect(rules["com.apple.Off"] == "",
               "an app rule with a blank source survives as an app left alone")

        suite.expect(Defaults.defaultInputSourceLockGuardIntervalSeconds == 2
                && Defaults.allowedInputSourceLockGuardIntervalRange == 1...60,
               "the guard starts at two seconds and can be set from one to sixty")
        suite.expect(Defaults.sanitizedInputSourceLockGuardInterval(1) == 1
                && Defaults.sanitizedInputSourceLockGuardInterval(60) == 60,
               "every interval in the allowed range is kept")
        suite.expect(Defaults.sanitizedInputSourceLockGuardInterval(0)
                == Defaults.defaultInputSourceLockGuardIntervalSeconds
                && Defaults.sanitizedInputSourceLockGuardInterval(61)
                == Defaults.defaultInputSourceLockGuardIntervalSeconds,
               "an interval outside the range falls back to the default")

        suite.expect(AppFeature.inputSourceLock.group == .mouseKeyboard
                && AppFeature.inputSourceLock.permissions.isEmpty
                && AppFeature.inputSourceLock.enabledKeys == [DefaultsKey.inputSourceLockEnabled]
                && AppFeature.inputSourceLock.energyProfile == .periodic
                && !AppFeature.inputSourceLock.installedByDefault,
               "the input source lock is an opt-in keyboard feature that needs no permission")
        suite.expect(FeatureVisibilitySupport.features(for: .inputSourceLock) == [.inputSourceLock]
                && AppFeature.inputSourceLock.settingsDestination
                    == FeatureSettingsDestination(.inputSourceLock)
                && !FeatureVisibilitySupport.isPageVisible(.inputSourceLock,
                                                           isAvailable: { _ in false }),
               "the input source lock page follows its own feature")

        suite.expect(Defaults.registeredDefaults[DefaultsKey.inputSourceLockShowSwitchNotice] as? Bool
                == false,
               "the Dynamic Island notice switch ships off")
        let backupKeys = SettingsBackupSupport.exportKeys()
        suite.expect(backupKeys.isSuperset(of: [
            DefaultsKey.inputSourceLockEnabled,
            DefaultsKey.inputSourceLockGlobalSourceID,
            DefaultsKey.inputSourceLockRules,
            DefaultsKey.inputSourceLockGuardIntervalSeconds,
            DefaultsKey.inputSourceLockShowSwitchNotice,
        ]), "the global source, app rules, guard interval and notice switch travel in a settings backup")
    }
}
