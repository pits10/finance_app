//
//  Enums.swift
//  FinanceApp
//
//  Core enumerations for the app
//

import Foundation

/// User theme selection
enum Theme: String, Codable, CaseIterable {
    case green = "green"
    case gold = "gold"

    var displayName: String {
        switch self {
        case .green: return "Neon Green"
        case .gold: return "Gold"
        }
    }
}

/// Privacy mode for user profile
enum PrivacyMode: String, Codable, CaseIterable {
    case open = "open"
    case balanced = "balanced"
    case private_ = "private"

    var displayName: String {
        switch self {
        case .open: return "Open"
        case .balanced: return "Balanced"
        case .private_: return "Private"
        }
    }

    var description: String {
        switch self {
        case .open: return "Show all activities and tickers to friends"
        case .balanced: return "Show activities and tickers, hide notes"
        case .private_: return "Show only weekly presence"
        }
    }
}

/// Friendship status
enum FriendshipStatus: String, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case blocked = "blocked"
}

/// Activity type for social feed
enum ActivityType: String, Codable {
    case checkIn = "CHECKIN"
    case watchAdd = "WATCH_ADD"
    case raiseAdd = "RAISE_ADD"
    case raiseLevelUp = "RAISE_LEVELUP"

    var displayVerb: String {
        switch self {
        case .checkIn: return "checked in"
        case .watchAdd: return "added to Watchlist"
        case .raiseAdd: return "started raising"
        case .raiseLevelUp: return "leveled up"
        }
    }
}

/// Asset level based on consistency streaks
enum AssetLevel: Int, Codable, CaseIterable {
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5

    var displayName: String {
        return "Lv. \(rawValue)"
    }

    var stageLabel: String {
        switch self {
        case .level1: return "Beginning"
        case .level2: return "Forming"
        case .level3: return "Growing"
        case .level4: return "Strengthening"
        case .level5: return "Mastered"
        }
    }

    var requiredStreak: Int {
        switch self {
        case .level1: return 1
        case .level2: return 3
        case .level3: return 7
        case .level4: return 21
        case .level5: return 60
        }
    }

    /// Calculate level from streak count
    static func from(streakCount: Int) -> AssetLevel {
        if streakCount >= 60 { return .level5 }
        if streakCount >= 21 { return .level4 }
        if streakCount >= 7 { return .level3 }
        if streakCount >= 3 { return .level2 }
        return .level1
    }
}
