//
//  WatchlistViewModel.swift
//  FinanceApp
//
//  Watchlist screen view model
//

import Foundation
import Observation

@MainActor
@Observable
final class WatchlistViewModel {
    var currentUser: User?
    var watchlistItems: [WatchlistItem] = []
    var showingAddItem = false
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
        watchlistItems = repository.fetchWatchlistItems(for: user.id)
    }

    func addWatchlistItem() {
        guard let user = currentUser else { return }
        guard !newTicker.isEmpty else { return }

        // Validate note length
        let trimmedNote = String(newNote.prefix(60))

        let item = WatchlistItem(
            ticker: newTicker.uppercased().trimmingCharacters(in: .whitespacesAndNewlines),
            tags: selectedTags,
            note: trimmedNote
        )

        do {
            try repository.saveWatchlistItem(item, for: user)

            // Create activity
            let activity = Activity(
                userId: user.id,
                type: .watchAdd,
                ticker: item.ticker
            )
            try repository.saveActivity(activity)

            // Reset form
            newTicker = ""
            newNote = ""
            selectedTags = []
            showingAddItem = false

            loadData()
        } catch {
            print("❌ Failed to add watchlist item: \(error)")
        }
    }

    func promoteToRaising(_ item: WatchlistItem) {
        guard let user = currentUser else { return }

        // Create asset from watchlist item
        let asset = Asset(
            ticker: item.ticker,
            tags: item.tags,
            note: item.note,
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

            // Remove from watchlist
            try repository.deleteWatchlistItem(item)

            loadData()
            print("✅ Promoted \(item.ticker) to Raising")
        } catch {
            print("❌ Failed to promote to raising: \(error)")
        }
    }

    func deleteWatchlistItem(_ item: WatchlistItem) {
        do {
            try repository.deleteWatchlistItem(item)
            loadData()
        } catch {
            print("❌ Failed to delete watchlist item: \(error)")
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
