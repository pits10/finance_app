//
//  LocalRepository.swift
//  FinanceApp
//
//  Local persistence repository using SwiftData
//

import Foundation
import SwiftData

@MainActor
final class LocalRepository: ObservableObject {
    private let modelContainer: ModelContainer
    private var modelContext: ModelContext

    init(inMemory: Bool = false) {
        do {
            let schema = Schema([
                User.self,
                Friendship.self,
                Asset.self,
                WatchlistItem.self,
                Activity.self,
                Yokune.self
            ])

            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: inMemory
            )

            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - User Operations

    func saveUser(_ user: User) throws {
        modelContext.insert(user)
        try modelContext.save()
    }

    func fetchCurrentUser() -> User? {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.onboardingCompleted == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try? modelContext.fetch(descriptor).first
    }

    func fetchUser(by id: UUID) -> User? {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }

    func updateUser(_ user: User) throws {
        try modelContext.save()
    }

    // MARK: - Asset Operations

    func saveAsset(_ asset: Asset, for user: User) throws {
        user.raisingAssets?.append(asset)
        modelContext.insert(asset)
        try modelContext.save()
    }

    func fetchAssets(for userId: UUID) -> [Asset] {
        let descriptor = FetchDescriptor<Asset>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let allAssets = (try? modelContext.fetch(descriptor)) ?? []
        return allAssets.filter { $0.user?.id == userId }
    }

    func deleteAsset(_ asset: Asset) throws {
        modelContext.delete(asset)
        try modelContext.save()
    }

    func updateAsset(_ asset: Asset) throws {
        try modelContext.save()
    }

    // MARK: - Watchlist Operations

    func saveWatchlistItem(_ item: WatchlistItem, for user: User) throws {
        user.watchlistItems?.append(item)
        modelContext.insert(item)
        try modelContext.save()
    }

    func fetchWatchlistItems(for userId: UUID) -> [WatchlistItem] {
        let descriptor = FetchDescriptor<WatchlistItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let allItems = (try? modelContext.fetch(descriptor)) ?? []
        return allItems.filter { $0.user?.id == userId }
    }

    func deleteWatchlistItem(_ item: WatchlistItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }

    // MARK: - Friendship Operations

    func saveFriendship(_ friendship: Friendship) throws {
        modelContext.insert(friendship)
        try modelContext.save()
    }

    func fetchFriendships(for userId: UUID) -> [Friendship] {
        let descriptor = FetchDescriptor<Friendship>()
        let allFriendships = (try? modelContext.fetch(descriptor)) ?? []
        return allFriendships.filter {
            ($0.userId == userId || $0.friendId == userId) && $0.status == .accepted
        }
    }

    func fetchPendingFriendRequests(for userId: UUID) -> [Friendship] {
        let descriptor = FetchDescriptor<Friendship>()
        let allFriendships = (try? modelContext.fetch(descriptor)) ?? []
        return allFriendships.filter {
            $0.friendId == userId && $0.status == .pending
        }
    }

    func updateFriendship(_ friendship: Friendship) throws {
        try modelContext.save()
    }

    // MARK: - Activity Operations

    func saveActivity(_ activity: Activity) throws {
        modelContext.insert(activity)
        try modelContext.save()
    }

    func fetchActivities(for userIds: [UUID], limit: Int = 50) -> [Activity] {
        let descriptor = FetchDescriptor<Activity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let allActivities = (try? modelContext.fetch(descriptor)) ?? []
        return Array(allActivities.filter { userIds.contains($0.userId) }.prefix(limit))
    }

    // MARK: - Yokune Operations

    func saveYokune(_ yokune: Yokune) throws {
        modelContext.insert(yokune)
        try modelContext.save()
    }

    func fetchYokunes(for activityId: UUID) -> [Yokune] {
        let descriptor = FetchDescriptor<Yokune>()
        let allYokunes = (try? modelContext.fetch(descriptor)) ?? []
        return allYokunes.filter { $0.activityId == activityId }
    }

    func hasYokuned(userId: UUID, activityId: UUID) -> Bool {
        let descriptor = FetchDescriptor<Yokune>()
        let allYokunes = (try? modelContext.fetch(descriptor)) ?? []
        return allYokunes.contains { $0.fromUserId == userId && $0.activityId == activityId }
    }

    func fetchTodaysYokuneCount(for userId: UUID) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        let descriptor = FetchDescriptor<Yokune>()
        let allYokunes = (try? modelContext.fetch(descriptor)) ?? []

        // Count Yokunes received by this user's activities today
        let userActivities = fetchActivities(for: [userId], limit: 1000)
        let activityIds = userActivities.map { $0.id }

        return allYokunes.filter {
            activityIds.contains($0.activityId) && $0.createdAt >= startOfDay
        }.count
    }

    // MARK: - Check-in Logic

    func performCheckIn(for user: User) throws -> [Activity] {
        var activities: [Activity] = []

        // Create check-in activity
        let checkInActivity = Activity(
            userId: user.id,
            type: .checkIn
        )
        try saveActivity(checkInActivity)
        activities.append(checkInActivity)

        // Update all raising assets
        let assets = fetchAssets(for: user.id)
        for asset in assets {
            let oldLevel = asset.level
            asset.checkIn()
            try updateAsset(asset)

            // If leveled up, create level-up activity
            if asset.level > oldLevel {
                let levelUpActivity = Activity(
                    userId: user.id,
                    type: .raiseLevelUp,
                    ticker: asset.ticker,
                    level: asset.level
                )
                try saveActivity(levelUpActivity)
                activities.append(levelUpActivity)
            }
        }

        return activities
    }

    // MARK: - Search Operations

    func searchUserByHandle(_ handle: String) -> User? {
        let descriptor = FetchDescriptor<User>()
        let allUsers = (try? modelContext.fetch(descriptor)) ?? []
        return allUsers.first { $0.handle?.lowercased() == handle.lowercased() }
    }

    func fetchAllUsers() -> [User] {
        let descriptor = FetchDescriptor<User>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
