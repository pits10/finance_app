//
//  AssetCard.swift
//  FinanceApp
//
//  Asset display card
//

import SwiftUI

struct AssetCard: View {
    let ticker: String
    let level: AssetLevel
    let tags: [String]
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            // Header
            HStack {
                Text(ticker)
                    .font(.system(size: DesignTokens.Typography.headline, weight: .bold))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Spacer()

                // Level badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text(level.displayName)
                        .font(.system(size: DesignTokens.Typography.small, weight: .semibold))
                }
                .foregroundColor(accentColor)
                .padding(.horizontal, DesignTokens.Spacing.sm)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .fill(accentColor.opacity(0.15))
                )
            }

            // Stage label
            Text(level.stageLabel)
                .font(.system(size: DesignTokens.Typography.small, weight: .medium))
                .foregroundColor(DesignTokens.Colors.textSecondary)

            // Tags
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: DesignTokens.Typography.small))
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                                .padding(.horizontal, DesignTokens.Spacing.sm)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                        .fill(DesignTokens.Colors.surface)
                                )
                        }
                    }
                }
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
}

#Preview {
    ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        VStack {
            AssetCard(
                ticker: "NVDA",
                level: .level3,
                tags: ["AI", "Datacenter", "Long-term"],
                accentColor: DesignTokens.Colors.accentGreen
            )
            .padding()
        }
    }
}
