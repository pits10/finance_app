//
//  MockDataGenerator.swift
//  FinanceApp
//
//  Generate mock data for testing and previews
//

import Foundation

struct MockDataGenerator {

    // MARK: - Users
    static func createMockUsers(count: Int = 5) -> [User] {
        let names = [
            "Mina Chen", "Alex Kim", "Jordan Lee", "Taylor Smith",
            "Sam Rivers", "Casey Morgan", "Riley Park", "Quinn Davis"
        ]

        return (0..<min(count, names.count)).map { index in
            let name = names[index]
            let handle = name.lowercased().replacingOccurrences(of: " ", with: "")
            return User(
                displayName: name,
                handle: handle,
                avatarSeed: "seed\(index)",
                theme: index % 2 == 0 ? .green : .gold,
                onboardingCompleted: true
            )
        }
    }

    // MARK: - Assets
    static func createMockAssets(for user: User, count: Int = 5) -> [Asset] {
        let tickers = ["NVDA", "AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "META", "BTC"]
        let tagSets = [
            ["AI", "Datacenter", "Long-term"],
            ["Tech", "Consumer", "Growth"],
            ["Cloud", "Enterprise", "SaaS"],
            ["Search", "Advertising", "AI"],
            ["E-commerce", "Cloud", "Logistics"],
            ["EV", "Energy", "Innovation"],
            ["Social", "VR", "Advertising"],
            ["Crypto", "Store of Value"]
        ]

        return (0..<min(count, tickers.count)).map { index in
            let asset = Asset(
                ticker: tickers[index],
                tags: tagSets[index],
                note: "Tracking for long-term growth",
                level: [1, 2, 3, 4, 5].randomElement() ?? 1,
                streakCount: [1, 3, 7, 21, 60].randomElement() ?? 1,
                createdAt: Date().addingTimeInterval(-Double(index) * 86400),
                lastCheckinAt: Date().addingTimeInterval(-Double.random(in: 0...86400))
            )
            return asset
        }
    }

    // MARK: - Watchlist Items
    static func createMockWatchlistItems(for user: User, count: Int = 3) -> [WatchlistItem] {
        let tickers = ["AMD", "NFLX", "DIS", "PYPL", "SQ"]
        let tagSets = [
            ["Semiconductors", "AI"],
            ["Streaming", "Entertainment"],
            ["Media", "Theme Parks"],
            ["Payments", "Fintech"],
            ["Fintech", "Payments"]
        ]

        return (0..<min(count, tickers.count)).map { index in
            WatchlistItem(
                ticker: tickers[index],
                tags: tagSets[index],
                note: "Considering",
                createdAt: Date().addingTimeInterval(-Double(index) * 3600)
            )
        }
    }

    // MARK: - Activities
    static func createMockActivities(for users: [User], count: Int = 20) -> [Activity] {
        let types: [ActivityType] = [.checkIn, .watchAdd, .raiseAdd, .raiseLevelUp]
        let tickers = ["NVDA", "AAPL", "MSFT", "GOOGL", "TSLA"]

        return (0..<count).map { index in
            let user = users.randomElement() ?? users[0]
            let type = types.randomElement() ?? .checkIn
            let ticker = type != .checkIn ? tickers.randomElement() : nil
            let level = type == .raiseLevelUp ? Int.random(in: 2...5) : nil

            return Activity(
                userId: user.id,
                type: type,
                ticker: ticker,
                level: level,
                createdAt: Date().addingTimeInterval(-Double(index) * 3600)
            )
        }
    }

    // MARK: - Friendships
    static func createMockFriendships(from user: User, to friends: [User]) -> [Friendship] {
        friends.map { friend in
            Friendship(
                userId: user.id,
                friendId: friend.id,
                status: .accepted,
                createdAt: Date().addingTimeInterval(-Double.random(in: 0...2592000)) // Random within 30 days
            )
        }
    }

    // MARK: - Yokunes
    static func createMockYokunes(from user: User, for activities: [Activity], count: Int = 10) -> [Yokune] {
        let selectedActivities = Array(activities.shuffled().prefix(count))
        return selectedActivities.map { activity in
            Yokune(
                fromUserId: user.id,
                activityId: activity.id,
                createdAt: Date().addingTimeInterval(-Double.random(in: 0...86400))
            )
        }
    }

    // MARK: - Populate Repository
    @MainActor
    static func populateRepository(_ repository: LocalRepository) {
        do {
            // Create main user
            let mainUser = User(
                displayName: "You",
                handle: "mainuser",
                theme: .green,
                onboardingCompleted: true
            )
            try repository.saveUser(mainUser)

            // Create friends
            let friends = createMockUsers(count: 5)
            for friend in friends {
                try repository.saveUser(friend)
            }

            // Create friendships
            let friendships = createMockFriendships(from: mainUser, to: friends)
            for friendship in friendships {
                try repository.saveFriendship(friendship)
            }

            // Create assets for main user
            let assets = createMockAssets(for: mainUser, count: 4)
            for asset in assets {
                try repository.saveAsset(asset, for: mainUser)
            }

            // Create watchlist items for main user
            let watchlistItems = createMockWatchlistItems(for: mainUser, count: 3)
            for item in watchlistItems {
                try repository.saveWatchlistItem(item, for: mainUser)
            }

            // Create activities for all users
            let allUsers = [mainUser] + friends
            let activities = createMockActivities(for: allUsers, count: 30)
            for activity in activities {
                try repository.saveActivity(activity)
            }

            // Create some yokunes
            let yokunes = createMockYokunes(from: mainUser, for: activities, count: 5)
            for yokune in yokunes {
                try repository.saveYokune(yokune)
            }

            print("✅ Mock data populated successfully")
        } catch {
            print("❌ Error populating mock data: \(error)")
        }
    }
}
