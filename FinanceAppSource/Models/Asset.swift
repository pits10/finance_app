//
//  Asset.swift
//  FinanceApp
//
//  Asset (Raising) model
//

import Foundation
import SwiftData

@Model
final class Asset {
    @Attribute(.unique) var id: UUID
    var ticker: String
    var tags: [String]
    var note: String // max 60 chars
    var level: Int // 1-5
    var streakCount: Int
    var createdAt: Date
    var lastCheckinAt: Date?

    // Inverse relationship
    var user: User?

    init(
        id: UUID = UUID(),
        ticker: String,
        tags: [String] = [],
        note: String = "",
        level: Int = 1,
        streakCount: Int = 1,
        createdAt: Date = Date(),
        lastCheckinAt: Date? = nil
    ) {
        self.id = id
        self.ticker = ticker.uppercased()
        self.tags = tags
        self.note = note
        self.level = level
        self.streakCount = streakCount
        self.createdAt = createdAt
        self.lastCheckinAt = lastCheckinAt
    }

    var assetLevel: AssetLevel {
        AssetLevel.from(streakCount: streakCount)
    }

    /// Check if streak is active (checked in within last 48 hours)
    var isStreakActive: Bool {
        guard let lastCheckin = lastCheckinAt else { return false }
        let hoursSinceCheckin = Date().timeIntervalSince(lastCheckin) / 3600
        return hoursSinceCheckin <= 48
    }

    /// Update streak on check-in
    func checkIn() {
        if let lastCheckin = lastCheckinAt {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let lastCheckinDay = calendar.startOfDay(for: lastCheckin)
            let daysDifference = calendar.dateComponents([.day], from: lastCheckinDay, to: today).day ?? 0

            if daysDifference == 1 {
                // Consecutive day - increment streak
                streakCount += 1
            } else if daysDifference == 0 {
                // Same day - no change
                return
            } else {
                // Missed days - reset streak
                streakCount = 1
            }
        } else {
            // First check-in
            streakCount = 1
        }

        lastCheckinAt = Date()
        level = AssetLevel.from(streakCount: streakCount).rawValue
    }
}
