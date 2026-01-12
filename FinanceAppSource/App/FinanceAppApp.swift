//
//  FinanceAppApp.swift
//  FinanceApp
//
//  Main app entry point
//

import SwiftUI
import SwiftData

@main
struct FinanceAppApp: App {
    @State private var repository: LocalRepository
    @State private var themeManager = ThemeManager()
    @State private var isOnboardingComplete = false
    @State private var hasMockData = false

    init() {
        // Initialize repository
        let repo = LocalRepository(inMemory: false)
        _repository = State(initialValue: repo)

        // Check if user has completed onboarding
        if let user = repo.fetchCurrentUser() {
            _isOnboardingComplete = State(initialValue: true)
            themeManager.setTheme(user.theme)
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isOnboardingComplete {
                    MainTabView(repository: repository, themeManager: themeManager)
                        .preferredColorScheme(.dark)
                        .onAppear {
                            loadUserTheme()
                            ensureMockDataOnce()
                        }
                } else {
                    OnboardingView(
                        isOnboardingComplete: $isOnboardingComplete,
                        repository: repository,
                        themeManager: themeManager
                    )
                    .preferredColorScheme(.dark)
                }
            }
        }
    }

    private func loadUserTheme() {
        if let user = repository.fetchCurrentUser() {
            themeManager.setTheme(user.theme)
        }
    }

    /// Populate mock data once for testing (only if database is empty)
    private func ensureMockDataOnce() {
        guard !hasMockData else { return }

        let allUsers = repository.fetchAllUsers()
        if allUsers.count <= 1 { // Only current user exists
            Task { @MainActor in
                MockDataGenerator.populateRepository(repository)
                hasMockData = true
            }
        } else {
            hasMockData = true
        }
    }
}
