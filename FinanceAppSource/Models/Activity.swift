//
//  Activity.swift
//  FinanceApp
//
//  User activity for social feed
//

import Foundation
import SwiftData

@Model
final class Activity: @unchecked Sendable {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var type: ActivityType
    var ticker: String? // optional for ticker-related activities
    var level: Int? // for level-up activities
    var createdAt: Date

    // Relationship
    @Relationship(deleteRule: .cascade)
    var yokunes: [Yokune]? = []

    init(
        id: UUID = UUID(),
        userId: UUID,
        type: ActivityType,
        ticker: String? = nil,
        level: Int? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.ticker = ticker?.uppercased()
        self.level = level
        self.createdAt = createdAt
    }

    /// Get display text for activity
    func displayText(userName: String) -> String {
        switch type {
        case .checkIn:
            return "\(userName) checked in"
        case .watchAdd:
            if let ticker = ticker {
                return "\(userName) added \(ticker) to Watchlist"
            }
            return "\(userName) added to Watchlist"
        case .raiseAdd:
            if let ticker = ticker {
                return "\(userName) started raising \(ticker)"
            }
            return "\(userName) started raising an asset"
        case .raiseLevelUp:
            if let ticker = ticker, let level = level {
                return "\(userName) leveled up \(ticker) to Lv. \(level)"
            }
            return "\(userName) leveled up"
        }
    }
}
