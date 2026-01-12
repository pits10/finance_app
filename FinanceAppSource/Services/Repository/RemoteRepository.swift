//
//  RemoteRepository.swift
//  FinanceApp
//
//  Remote repository protocol for future Supabase integration
//  TODO: Implement with Supabase SDK
//

import Foundation

protocol RemoteRepository {
    // MARK: - Authentication
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() async throws -> User?

    // MARK: - User Operations
    func updateUser(_ user: User) async throws
    func searchUsers(query: String) async throws -> [User]

    // MARK: - Asset Operations
    func syncAssets(userId: UUID) async throws -> [Asset]
    func saveAsset(_ asset: Asset) async throws

    // MARK: - Watchlist Operations
    func syncWatchlist(userId: UUID) async throws -> [WatchlistItem]
    func saveWatchlistItem(_ item: WatchlistItem) async throws

    // MARK: - Friendship Operations
    func sendFriendRequest(from: UUID, to: UUID) async throws
    func acceptFriendRequest(friendshipId: UUID) async throws
    func fetchFriends(userId: UUID) async throws -> [User]

    // MARK: - Activity Operations
    func syncActivities(userId: UUID, since: Date?) async throws -> [Activity]
    func fetchFriendsActivities(userId: UUID) async throws -> [Activity]

    // MARK: - Yokune Operations
    func sendYokune(from: UUID, activityId: UUID) async throws
    func fetchYokunes(activityId: UUID) async throws -> [Yokune]

    // MARK: - Real-time Subscriptions
    func subscribeToFriendsActivities(userId: UUID, callback: @escaping ([Activity]) -> Void)
    func subscribeToYokunes(userId: UUID, callback: @escaping (Yokune) -> Void)
}

// MARK: - Stub Implementation
final class SupabaseRepository: RemoteRepository {
    // TODO: Initialize Supabase client
    // private let client: SupabaseClient

    func signIn(email: String, password: String) async throws -> User {
        throw RepositoryError.notImplemented
    }

    func signUp(email: String, password: String, displayName: String) async throws -> User {
        throw RepositoryError.notImplemented
    }

    func signOut() async throws {
        throw RepositoryError.notImplemented
    }

    func getCurrentUser() async throws -> User? {
        throw RepositoryError.notImplemented
    }

    func updateUser(_ user: User) async throws {
        throw RepositoryError.notImplemented
    }

    func searchUsers(query: String) async throws -> [User] {
        throw RepositoryError.notImplemented
    }

    func syncAssets(userId: UUID) async throws -> [Asset] {
        throw RepositoryError.notImplemented
    }

    func saveAsset(_ asset: Asset) async throws {
        throw RepositoryError.notImplemented
    }

    func syncWatchlist(userId: UUID) async throws -> [WatchlistItem] {
        throw RepositoryError.notImplemented
    }

    func saveWatchlistItem(_ item: WatchlistItem) async throws {
        throw RepositoryError.notImplemented
    }

    func sendFriendRequest(from: UUID, to: UUID) async throws {
        throw RepositoryError.notImplemented
    }

    func acceptFriendRequest(friendshipId: UUID) async throws {
        throw RepositoryError.notImplemented
    }

    func fetchFriends(userId: UUID) async throws -> [User] {
        throw RepositoryError.notImplemented
    }

    func syncActivities(userId: UUID, since: Date?) async throws -> [Activity] {
        throw RepositoryError.notImplemented
    }

    func fetchFriendsActivities(userId: UUID) async throws -> [Activity] {
        throw RepositoryError.notImplemented
    }

    func sendYokune(from: UUID, activityId: UUID) async throws {
        throw RepositoryError.notImplemented
    }

    func fetchYokunes(activityId: UUID) async throws -> [Yokune] {
        throw RepositoryError.notImplemented
    }

    func subscribeToFriendsActivities(userId: UUID, callback: @escaping ([Activity]) -> Void) {
        // TODO: Implement real-time subscription
    }

    func subscribeToYokunes(userId: UUID, callback: @escaping (Yokune) -> Void) {
        // TODO: Implement real-time subscription
    }
}

enum RepositoryError: Error {
    case notImplemented
    case networkError
    case authenticationFailed
    case notFound
}
