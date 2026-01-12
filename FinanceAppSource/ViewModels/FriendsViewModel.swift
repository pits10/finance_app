//
//  FriendsViewModel.swift
//  FinanceApp
//
//  Friends screen view model
//

import Foundation
import Observation

@MainActor
@Observable
final class FriendsViewModel {
    var currentUser: User?
    var friends: [User] = []
    var activities: [Activity] = []
    var activityUsers: [UUID: User] = [:] // Cache users for activities
    var yokunedActivities: Set<UUID> = [] // Track which activities current user has yokuned

    private let repository: LocalRepository

    init(repository: LocalRepository) {
        self.repository = repository
        loadData()
    }

    func loadData() {
        currentUser = repository.fetchCurrentUser()
        guard let user = currentUser else { return }

        // Load friends
        let friendships = repository.fetchFriendships(for: user.id)
        let friendIds = friendships.map { friendship in
            friendship.userId == user.id ? friendship.friendId : friendship.userId
        }

        friends = friendIds.compactMap { friendId in
            repository.fetchUser(by: friendId)
        }

        // Load activities from friends
        activities = repository.fetchActivities(for: friendIds, limit: 50)

        // Load users for activities
        let allUserIds = Set(activities.map { $0.userId })
        for userId in allUserIds {
            if let user = repository.fetchUser(by: userId) {
                activityUsers[userId] = user
            }
        }

        // Load yokuned activities
        loadYokunedActivities()
    }

    func sendYokune(to activity: Activity) {
        guard let user = currentUser else { return }

        // Check if already yokuned
        if repository.hasYokuned(userId: user.id, activityId: activity.id) {
            print("⚠️ Already yokuned this activity")
            return
        }

        let yokune = Yokune(
            fromUserId: user.id,
            activityId: activity.id
        )

        do {
            try repository.saveYokune(yokune)
            yokunedActivities.insert(activity.id)
            print("✅ Yokune sent!")
        } catch {
            print("❌ Failed to send Yokune: \(error)")
        }
    }

    func hasYokuned(activityId: UUID) -> Bool {
        yokunedActivities.contains(activityId)
    }

    private func loadYokunedActivities() {
        guard let user = currentUser else { return }

        yokunedActivities = Set(
            activities.filter { activity in
                repository.hasYokuned(userId: user.id, activityId: activity.id)
            }.map { $0.id }
        )
    }
}
