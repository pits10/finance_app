//
//  MainTabView.swift
//  FinanceApp
//
//  Main tab navigation
//

import SwiftUI

struct MainTabView: View {
    let repository: LocalRepository
    let themeManager: ThemeManager

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView(repository: repository, themeManager: themeManager)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            // Raise Tab
            RaiseView(repository: repository, themeManager: themeManager)
                .tabItem {
                    Label("Raise", systemImage: selectedTab == 1 ? "arrow.up.circle.fill" : "arrow.up.circle")
                }
                .tag(1)

            // Watchlist Tab
            WatchlistView(repository: repository, themeManager: themeManager)
                .tabItem {
                    Label("Watchlist", systemImage: selectedTab == 2 ? "eye.fill" : "eye")
                }
                .tag(2)

            // Friends Tab
            FriendsView(repository: repository, themeManager: themeManager)
                .tabItem {
                    Label("Friends", systemImage: selectedTab == 3 ? "person.2.fill" : "person.2")
                }
                .tag(3)
        }
        .tint(themeManager.accentColor)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(DesignTokens.Colors.surface)

        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(DesignTokens.Colors.textTertiary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.textTertiary)
        ]

        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(themeManager.accentColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(themeManager.accentColor)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
