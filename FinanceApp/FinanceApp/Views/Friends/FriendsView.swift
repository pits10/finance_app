//
//  FriendsView.swift
//  FinanceApp
//
//  Friends screen with Orbit UI (MOST IMPORTANT SCREEN)
//

import SwiftUI

struct FriendsView: View {
    @State private var viewModel: FriendsViewModel
    let repository: LocalRepository
    let themeManager: ThemeManager

    init(repository: LocalRepository, themeManager: ThemeManager) {
        self._viewModel = State(initialValue: FriendsViewModel(repository: repository))
        self.repository = repository
        self.themeManager = themeManager
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DesignTokens.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.xl) {
                        // Header
                        HStack {
                            Text("Friends")
                                .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                                .foregroundColor(DesignTokens.Colors.textPrimary)

                            Spacer()

                            NavigationLink(destination: AddFriendsView(repository: repository, themeManager: themeManager)) {
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(themeManager.accentColor)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.lg)

                        // Friends Orbit
                        if !viewModel.friends.isEmpty {
                            OrbitFriendsView(
                                friends: viewModel.friends,
                                accentColor: themeManager.accentColor
                            )
                            .frame(height: 300)
                            .padding(.vertical, DesignTokens.Spacing.lg)
                        } else {
                            EmptyOrbitView(accentColor: themeManager.accentColor)
                                .frame(height: 300)
                                .padding(.vertical, DesignTokens.Spacing.lg)
                        }

                        // Activity Feed
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            Text("Recent Activity")
                                .font(.system(size: DesignTokens.Typography.title, weight: .bold))
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                                .padding(.horizontal, DesignTokens.Spacing.lg)

                            if viewModel.activities.isEmpty {
                                EmptyStateView(
                                    icon: "person.2.circle",
                                    title: "No activity yet",
                                    message: "Add friends to see their progress"
                                )
                                .padding(.top, DesignTokens.Spacing.xl)
                            } else {
                                VStack(spacing: DesignTokens.Spacing.md) {
                                    ForEach(viewModel.activities, id: \.id) { activity in
                                        if let user = viewModel.activityUsers[activity.userId] {
                                            ActivityCard(
                                                activity: activity,
                                                user: user,
                                                hasYokuned: viewModel.hasYokuned(activityId: activity.id),
                                                accentColor: themeManager.accentColor,
                                                onYokune: {
                                                    viewModel.sendYokune(to: activity)
                                                }
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignTokens.Spacing.lg)
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

// MARK: - Empty Orbit View
struct EmptyOrbitView: View {
    let accentColor: Color
    @State private var isPulsing = false

    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2

            ZStack {
                // Central pulse
                PulseView(size: 80, color: accentColor)
                    .position(x: centerX, y: centerY)

                // Empty message
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Spacer()

                    Image(systemName: "person.2.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(DesignTokens.Colors.textTertiary)

                    Text("Add friends to see them here")
                        .font(.system(size: DesignTokens.Typography.caption))
                        .foregroundColor(DesignTokens.Colors.textTertiary)
                }
                .position(x: centerX, y: centerY + 120)
            }
        }
    }
}

#Preview {
    let repository = LocalRepository(inMemory: true)
    MockDataGenerator.populateRepository(repository)

    return FriendsView(
        repository: repository,
        themeManager: ThemeManager()
    )
}
