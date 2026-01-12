//
//  HomeView.swift
//  FinanceApp
//
//  Home screen
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    let themeManager: ThemeManager

    init(repository: LocalRepository, themeManager: ThemeManager) {
        self._viewModel = State(initialValue: HomeViewModel(repository: repository))
        self.themeManager = themeManager
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DesignTokens.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.xl) {
                        // Header
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Text("Hello, \(viewModel.currentUser?.displayName ?? "Friend")")
                                .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Keep your momentum going")
                                .font(.system(size: DesignTokens.Typography.body))
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.lg)

                        // Today's Yokune Count
                        if viewModel.todaysYokuneCount > 0 {
                            HStack(spacing: DesignTokens.Spacing.md) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(themeManager.accentColor)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Today's Yokune")
                                        .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                                        .foregroundColor(DesignTokens.Colors.textSecondary)

                                    Text("\(viewModel.todaysYokuneCount)")
                                        .font(.system(size: DesignTokens.Typography.headline, weight: .bold))
                                        .foregroundColor(DesignTokens.Colors.textPrimary)
                                }

                                Spacer()
                            }
                            .padding(DesignTokens.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                    .fill(themeManager.accentColor.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                            .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, DesignTokens.Spacing.lg)
                        }

                        // Check-in Button
                        CheckInButton(
                            hasCheckedIn: viewModel.hasCheckedInToday,
                            accentColor: themeManager.accentColor,
                            action: {
                                viewModel.performCheckIn()
                            }
                        )
                        .padding(.horizontal, DesignTokens.Spacing.lg)

                        // My Raising Assets
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            HStack {
                                Text("My Raising Assets")
                                    .font(.system(size: DesignTokens.Typography.title, weight: .bold))
                                    .foregroundColor(DesignTokens.Colors.textPrimary)

                                Spacer()

                                Text("\(viewModel.raisingAssets.count)")
                                    .font(.system(size: DesignTokens.Typography.headline, weight: .semibold))
                                    .foregroundColor(themeManager.accentColor)
                            }
                            .padding(.horizontal, DesignTokens.Spacing.lg)

                            if viewModel.raisingAssets.isEmpty {
                                EmptyStateView(
                                    icon: "arrow.up.circle",
                                    title: "No assets yet",
                                    message: "Add your first asset to start building your habit"
                                )
                                .padding(.horizontal, DesignTokens.Spacing.lg)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: DesignTokens.Spacing.md) {
                                        ForEach(viewModel.raisingAssets.prefix(5), id: \.id) { asset in
                                            AssetCard(
                                                ticker: asset.ticker,
                                                level: asset.assetLevel,
                                                tags: asset.tags,
                                                accentColor: themeManager.accentColor
                                            )
                                            .frame(width: 280)
                                        }
                                    }
                                    .padding(.horizontal, DesignTokens.Spacing.lg)
                                }
                            }
                        }

                        Spacer()
                            .frame(height: DesignTokens.Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

// MARK: - Check-in Button
struct CheckInButton: View {
    let hasCheckedIn: Bool
    let accentColor: Color
    let action: () -> Void

    @State private var isPulsing = false

    var body: some View {
        Button(action: {
            if !hasCheckedIn {
                action()
            }
        }) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: hasCheckedIn ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 32))
                    .foregroundColor(hasCheckedIn ? DesignTokens.Colors.textTertiary : accentColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(hasCheckedIn ? "Checked in today" : "Today's Check-in")
                        .font(.system(size: DesignTokens.Typography.headline, weight: .bold))
                        .foregroundColor(hasCheckedIn ? DesignTokens.Colors.textSecondary : DesignTokens.Colors.textPrimary)

                    Text(hasCheckedIn ? "Come back tomorrow" : "Tap to build your streak")
                        .font(.system(size: DesignTokens.Typography.caption))
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }

                Spacer()

                if !hasCheckedIn {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(accentColor)
                        .scaleEffect(isPulsing ? 1.1 : 1.0)
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(hasCheckedIn ? DesignTokens.Colors.surface : accentColor.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .stroke(hasCheckedIn ? DesignTokens.Colors.border : accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: hasCheckedIn ? .clear : accentColor.opacity(0.2), radius: DesignTokens.Shadows.glow)
        }
        .disabled(hasCheckedIn)
        .onAppear {
            if !hasCheckedIn {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(DesignTokens.Colors.textTertiary)

            Text(title)
                .font(.system(size: DesignTokens.Typography.headline, weight: .semibold))
                .foregroundColor(DesignTokens.Colors.textSecondary)

            Text(message)
                .font(.system(size: DesignTokens.Typography.body))
                .foregroundColor(DesignTokens.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(DesignTokens.Spacing.xl)
    }
}
