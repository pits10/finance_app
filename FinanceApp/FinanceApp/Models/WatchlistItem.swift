//
//  WatchlistItem.swift
//  FinanceApp
//
//  Watchlist item model
//

import Foundation
import SwiftData

@Model
final class WatchlistItem {
    @Attribute(.unique) var id: UUID
    var ticker: String
    var tags: [String]
    var note: String // max 60 chars
    var createdAt: Date

    // Inverse relationship
    var user: User?

    init(
        id: UUID = UUID(),
        ticker: String,
        tags: [String] = [],
        note: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.ticker = ticker.uppercased()
        self.tags = tags
        self.note = note
        self.createdAt = createdAt
    }
}
