//
//  AddFriendsViewModel.swift
//  FinanceApp
//
//  Add Friends screen view model
//

import Foundation
import Observation

@MainActor
@Observable
final class AddFriendsViewModel {
    var currentUser: User?
    var inviteCode: String = ""
    var searchHandle: String = ""
    var searchResult: User?
    var pendingRequests: [Friendship] = []
    var pendingUsers: [User] = []
    var isSearching = false

    private let repository: LocalRepository

    init(repository: LocalRepository) {
        self.repository = repository
        loadData()
    }

    func loadData() {
        currentUser = repository.fetchCurrentUser()
        guard let user = currentUser else { return }

        inviteCode = generateInviteCode(for: user)

        // Load pending friend requests
        pendingRequests = repository.fetchPendingFriendRequests(for: user.id)
        pendingUsers = pendingRequests.compactMap { friendship in
            repository.fetchUser(by: friendship.userId)
        }
    }

    func searchUser() {
        guard !searchHandle.isEmpty else {
            searchResult = nil
            return
        }

        isSearching = true
        searchResult = repository.searchUserByHandle(searchHandle)
        isSearching = false
    }

    func sendFriendRequest(to user: User) {
        guard let currentUser = currentUser else { return }
        guard user.id != currentUser.id else {
            print("⚠️ Cannot send friend request to yourself")
            return
        }

        let friendship = Friendship(
            userId: currentUser.id,
            friendId: user.id,
            status: .pending
        )

        do {
            try repository.saveFriendship(friendship)
            print("✅ Friend request sent to \(user.displayName)")
            searchResult = nil
            searchHandle = ""
        } catch {
            print("❌ Failed to send friend request: \(error)")
        }
    }

    func acceptFriendRequest(_ friendship: Friendship) {
        friendship.status = .accepted

        do {
            try repository.updateFriendship(friendship)
            print("✅ Friend request accepted")
            loadData()
        } catch {
            print("❌ Failed to accept friend request: \(error)")
        }
    }

    func declineFriendRequest(_ friendship: Friendship) {
        friendship.status = .blocked

        do {
            try repository.updateFriendship(friendship)
            print("✅ Friend request declined")
            loadData()
        } catch {
            print("❌ Failed to decline friend request: \(error)")
        }
    }

    private func generateInviteCode(for user: User) -> String {
        // Generate a simple invite code based on user ID
        let shortId = String(user.id.uuidString.prefix(8)).uppercased()
        return "INV-\(shortId)"
    }
}
