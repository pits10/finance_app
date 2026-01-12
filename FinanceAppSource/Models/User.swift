//
//  User.swift
//  FinanceApp
//
//  User model with SwiftData
//

import Foundation
import SwiftData

@Model
final class User: @unchecked Sendable {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var handle: String? // optional @handle
    var avatarSeed: String // for generating consistent avatar
    var theme: Theme
    var privacyMode: PrivacyMode
    var createdAt: Date
    var onboardingCompleted: Bool

    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Asset.user)
    var raisingAssets: [Asset]? = []

    @Relationship(deleteRule: .cascade, inverse: \WatchlistItem.user)
    var watchlistItems: [WatchlistItem]? = []

    @Relationship(deleteRule: .cascade)
    var activities: [Activity]? = []

    init(
        id: UUID = UUID(),
        displayName: String,
        handle: String? = nil,
        avatarSeed: String = UUID().uuidString,
        theme: Theme = .green,
        privacyMode: PrivacyMode = .balanced,
        createdAt: Date = Date(),
        onboardingCompleted: Bool = false
    ) {
        self.id = id
        self.displayName = displayName
        self.handle = handle
        self.avatarSeed = avatarSeed
        self.theme = theme
        self.privacyMode = privacyMode
        self.createdAt = createdAt
        self.onboardingCompleted = onboardingCompleted
    }

    /// Computed: today's Yokune count (must be computed via repository)
    var todaysYokuneCount: Int {
        return 0 // Computed dynamically in repository
    }
}
