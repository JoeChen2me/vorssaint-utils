// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import SwiftUI
import UniformTypeIdentifiers

/// The multi-select app picker the input source lock's per-app rules use. One
/// tap chooses an app, more taps add more: a single app and a whole group are
/// the same gesture, and Return or Add commits whatever is checked.
struct InputSourceAppPickerView: View {
    let title: String
    let searchPlaceholder: String
    let browseTitle: String
    let cancelTitle: String
    let addTitle: String
    let emptyText: String
    let selectedFormat: String
    let excludedBundleIDs: Set<String>
    let onCancel: () -> Void
    let onAdd: ([String]) -> Void

    @State private var apps: [InstalledApps.InstalledApp] = []
    @State private var selectedBundleIDs: Set<String> = []
    @State private var query = ""
    @State private var isLoading = false
    @State private var isBrowsing = false

    private var filteredApps: [InstalledApps.InstalledApp] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return apps }
        return apps.filter { app in
            app.name.localizedCaseInsensitiveContains(trimmed)
                || (app.bundleID?.localizedCaseInsensitiveContains(trimmed) ?? false)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            TextField(searchPlaceholder, text: $query)
                .textFieldStyle(.roundedBorder)
            appList
            footer
        }
        .padding(18)
        .frame(width: 520, height: 560)
        .onAppear(perform: loadAppsIfNeeded)
        .fileImporter(isPresented: $isBrowsing,
                      allowedContentTypes: [.applicationBundle],
                      allowsMultipleSelection: true) { result in
            guard let urls = try? result.get() else { return }
            addBrowsedApps(urls)
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Button {
                isBrowsing = true
            } label: {
                Label(browseTitle, systemImage: "folder")
            }
            Button(cancelTitle, action: onCancel)
                .keyboardShortcut(.cancelAction)
        }
    }

    @ViewBuilder
    private var appList: some View {
        let apps = filteredApps
        if isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if apps.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "app.dashed")
                    .font(.system(size: 34, weight: .light))
                    .foregroundStyle(.secondary)
                Text(emptyText)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    ForEach(apps) { app in
                        if let bundleID = app.bundleID {
                            Button {
                                toggle(bundleID)
                            } label: {
                                row(for: app, isSelected: selectedBundleIDs.contains(bundleID))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical, 3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var footer: some View {
        HStack {
            Text(String(format: selectedFormat, selectedBundleIDs.count))
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            Spacer()
            Button(addTitle) {
                onAdd(Array(selectedBundleIDs))
            }
            .keyboardShortcut(.defaultAction)
            .disabled(selectedBundleIDs.isEmpty)
        }
    }

    private func row(for app: InstalledApps.InstalledApp, isSelected: Bool) -> some View {
        HStack(spacing: 9) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14))
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            Image(nsImage: app.icon)
                .resizable()
                .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: 1) {
                Text(app.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                Text(app.bundleID ?? app.url.path)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(app.name), \(app.bundleID ?? app.url.path)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .padding(.horizontal, 7)
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.primary.opacity(0.001))
        }
    }

    private func toggle(_ bundleID: String) {
        if selectedBundleIDs.contains(bundleID) {
            selectedBundleIDs.remove(bundleID)
        } else {
            selectedBundleIDs.insert(bundleID)
        }
    }

    private func loadAppsIfNeeded() {
        guard apps.isEmpty, !isLoading else { return }
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let loaded = InstalledApps.installedBundleApplications(
                excluding: excludedBundleIDs,
                includeRunningApplications: true)
                .filter { $0.bundleID != nil }
            DispatchQueue.main.async {
                apps = loaded
                isLoading = false
            }
        }
    }

    /// A bundle outside the application folders still has a stable identifier
    /// to store, so browsing keeps the same identity the list rows use.
    private func addBrowsedApps(_ urls: [URL]) {
        var known = Set(apps.compactMap(\.bundleID))
        for url in urls {
            guard let bundleID = Bundle(url: url)?.bundleIdentifier,
                  !excludedBundleIDs.contains(bundleID) else { continue }
            selectedBundleIDs.insert(bundleID)
            guard known.insert(bundleID).inserted else { continue }
            let name = InstalledApps.displayName(
                fromFinderName: FileManager.default.displayName(atPath: url.path))
            apps.append(InstalledApps.InstalledApp(
                id: url.standardizedFileURL.path,
                name: name,
                bundleID: bundleID,
                url: url,
                isSystem: InstalledApps.isSystemApplication(at: url)))
        }
        apps.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
