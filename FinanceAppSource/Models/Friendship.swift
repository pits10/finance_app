//
//  Friendship.swift
//  FinanceApp
//
//  Friendship relationship model
//

import Foundation
import SwiftData

@Model
final class Friendship {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var friendId: UUID
    var status: FriendshipStatus
    var createdAt: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        friendId: UUID,
        status: FriendshipStatus = .pending,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.friendId = friendId
        self.status = status
        self.createdAt = createdAt
    }
}
