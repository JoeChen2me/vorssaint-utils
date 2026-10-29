// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// Which input source an app should keep. Every decision is a plain value test
/// so the guard can be covered without touching the system's text input
/// services or switching a real source.
enum InputSourceLockSupport {
    /// The source the frontmost app should use, or nil when it should be left
    /// alone.
    ///
    /// A listed app keeps its own source even when that source has been
    /// disabled in System Settings: the rule then leaves the app alone instead
    /// of quietly applying the global source the user chose for everything
    /// else. The app whose panels are borrowing a layout, this one, is never a
    /// target, so the Command Bar's ASCII layout keeps working.
    static func targetSourceID(frontmostBundleID: String?,
                               ownBundleID: String?,
                               globalSourceID: String,
                               rules: [String: String],
                               enabledSourceIDs: Set<String>) -> String? {
        guard let sourceID = candidateSourceID(frontmostBundleID: frontmostBundleID,
                                               ownBundleID: ownBundleID,
                                               globalSourceID: globalSourceID,
                                               rules: rules),
              enabledSourceIDs.contains(sourceID) else { return nil }
        return sourceID
    }

    /// The source the rules name for an app, before asking whether the system
    /// still has it enabled. The guard reads the current source first and only
    /// pays for an enabled-source listing when this candidate differs from it.
    static func candidateSourceID(frontmostBundleID: String?,
                                  ownBundleID: String?,
                                  globalSourceID: String,
                                  rules: [String: String]) -> String? {
        guard let bundleID = normalized(frontmostBundleID),
              bundleID != normalized(ownBundleID) else { return nil }
        if let rule = rules[bundleID] {
            return normalized(rule)
        }
        return normalized(globalSourceID)
    }

    /// The source a newly added app row starts on. A usable global source is
    /// the useful default; otherwise the row starts on "Don't change" and the
    /// person picks a source for it. Silently locking a new app to the system's
    /// first source would be a choice nobody made.
    static func preferredSourceForNewRule(globalSourceID: String,
                                          availableSourceIDs: Set<String>) -> String {
        guard let globalSourceID = normalized(globalSourceID),
              availableSourceIDs.contains(globalSourceID) else { return "" }
        return globalSourceID
    }

    /// Whether the guard owes the app a switch. A source it cannot read yet
    /// still counts as a mismatch, so the next read can settle it.
    static func needsCorrection(currentSourceID: String?, targetSourceID: String?) -> Bool {
        guard let targetSourceID = normalized(targetSourceID) else { return false }
        return currentSourceID != targetSourceID
    }

    /// Whether there is anything to guard at all. A feature left on with no
    /// global source and no app rules should cost nothing.
    static func hasConfiguredTarget(globalSourceID: String, rules: [String: String]) -> Bool {
        if normalized(globalSourceID) != nil { return true }
        return rules.values.contains { normalized($0) != nil }
    }

    /// App rules as stored in defaults. Entries no source could ever match are
    /// dropped; an app whose own source is empty stays empty, which leaves it
    /// alone rather than inheriting the global source by accident.
    static func sanitizedRules(_ stored: [String: Any]?) -> [String: String] {
        guard let stored else { return [:] }
        var rules: [String: String] = [:]
        for (bundleID, value) in stored {
            guard let bundleID = normalized(bundleID), let sourceID = value as? String else {
                continue
            }
            rules[bundleID] = sourceID.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return rules
    }

    private static func normalized(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else { return nil }
        return trimmed
    }
}
