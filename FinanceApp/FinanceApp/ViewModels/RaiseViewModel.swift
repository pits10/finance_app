//
//  RaiseViewModel.swift
//  FinanceApp
//
//  Raise (Assets) screen view model
//

import Foundation
import Observation

@MainActor
@Observable
final class RaiseViewModel {
    var currentUser: User?
    var raisingAssets: [Asset] = []
    var showingAddAsset = false
    var newTicker: String = ""
    var newNote: String = ""
    var selectedTags: [String] = []

    private let repository: LocalRepository

    let availableTags = [
        "AI", "Datacenter", "Defense", "Long-term", "Growth",
        "Tech", "Energy", "Finance", "Healthcare", "Consumer",
        "Cloud", "SaaS", "Hardware", "Software", "Crypto"
    ]

    init(repository: LocalRepository) {
        self.repository = repository
        loadData()
    }

    func loadData() {
        currentUser = repository.fetchCurrentUser()
        guard let user = currentUser else { return }
        raisingAssets = repository.fetchAssets(for: user.id)
    }

    func addAsset() {
        guard let user = currentUser else { return }
        guard !newTicker.isEmpty else { return }

        // Validate note length
        let trimmedNote = String(newNote.prefix(60))

        let asset = Asset(
            ticker: newTicker.uppercased().trimmingCharacters(in: .whitespacesAndNewlines),
            tags: selectedTags,
            note: trimmedNote,
            level: 1,
            streakCount: 1,
            lastCheckinAt: Date()
        )

        do {
            try repository.saveAsset(asset, for: user)

            // Create activity
            let activity = Activity(
                userId: user.id,
                type: .raiseAdd,
                ticker: asset.ticker
            )
            try repository.saveActivity(activity)

            // Reset form
            newTicker = ""
            newNote = ""
            selectedTags = []
            showingAddAsset = false

            loadData()
        } catch {
            print("❌ Failed to add asset: \(error)")
        }
    }

    func deleteAsset(_ asset: Asset) {
        do {
            try repository.deleteAsset(asset)
            loadData()
        } catch {
            print("❌ Failed to delete asset: \(error)")
        }
    }

    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
    }
}
