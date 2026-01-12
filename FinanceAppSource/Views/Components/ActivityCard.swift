//
//  ActivityCard.swift
//  FinanceApp
//
//  Activity feed card with Yokune button
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    let user: User
    let hasYokuned: Bool
    let accentColor: Color
    let onYokune: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // User info
            HStack(spacing: DesignTokens.Spacing.sm) {
                FriendAvatarView(
                    displayName: user.displayName,
                    avatarSeed: user.avatarSeed,
                    size: 40
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.displayName)
                        .font(.system(size: DesignTokens.Typography.body, weight: .semibold))
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    Text(timeAgo(from: activity.createdAt))
                        .font(.system(size: DesignTokens.Typography.small))
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }

                Spacer()
            }

            // Activity content
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(activityText)
                    .font(.system(size: DesignTokens.Typography.body))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                if let ticker = activity.ticker {
                    HStack {
                        Image(systemName: iconForActivityType)
                            .font(.system(size: 14))
                            .foregroundColor(accentColor)
                        Text(ticker)
                            .font(.system(size: DesignTokens.Typography.body, weight: .semibold))
                            .foregroundColor(accentColor)

                        if let level = activity.level {
                            Text("→ Lv. \(level)")
                                .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(accentColor.opacity(0.1))
                    )
                }
            }

            // Yokune button
            HStack {
                Spacer()
                YokuneButton(
                    accentColor: accentColor,
                    hasYokuned: hasYokuned,
                    action: onYokune
                )
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(DesignTokens.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .stroke(DesignTokens.Colors.border, lineWidth: 1)
                )
        )
    }

    private var activityText: String {
        switch activity.type {
        case .checkIn:
            return "Checked in today"
        case .watchAdd:
            return "Added to Watchlist"
        case .raiseAdd:
            return "Started raising"
        case .raiseLevelUp:
            return "Leveled up!"
        }
    }

    private var iconForActivityType: String {
        switch activity.type {
        case .checkIn: return "checkmark.circle.fill"
        case .watchAdd: return "eye.fill"
        case .raiseAdd: return "arrow.up.circle.fill"
        case .raiseLevelUp: return "star.fill"
        }
    }

    private func timeAgo(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        let minutes = Int(seconds / 60)
        let hours = Int(seconds / 3600)
        let days = Int(seconds / 86400)

        if days > 0 {
            return "\(days)d ago"
        } else if hours > 0 {
            return "\(hours)h ago"
        } else if minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "just now"
        }
    }
}

#Preview {
    let mockUser = User(displayName: "Mina Chen", avatarSeed: "seed1")
    let mockActivity = Activity(
        userId: mockUser.id,
        type: .raiseAdd,
        ticker: "NVDA",
        createdAt: Date().addingTimeInterval(-3600)
    )

    return ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        ActivityCard(
            activity: mockActivity,
            user: mockUser,
            hasYokuned: false,
            accentColor: DesignTokens.Colors.accentGreen,
            onYokune: {}
        )
        .padding()
    }
}
