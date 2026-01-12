//
//  OnboardingViewModel.swift
//  FinanceApp
//
//  Onboarding flow view model
//

import Foundation
import Observation

@MainActor
@Observable
final class OnboardingViewModel {
    var displayName: String = ""
    var handle: String = ""
    var selectedTheme: Theme = .green
    var selectedPrivacyMode: PrivacyMode = .balanced

    private let repository: LocalRepository

    var isDisplayNameValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(repository: LocalRepository) {
        self.repository = repository
    }

    func completeOnboarding() throws -> User {
        guard isDisplayNameValid else {
            throw OnboardingError.invalidDisplayName
        }

        let user = User(
            displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
            handle: handle.isEmpty ? nil : handle.trimmingCharacters(in: .whitespacesAndNewlines),
            theme: selectedTheme,
            privacyMode: selectedPrivacyMode,
            onboardingCompleted: true
        )

        try repository.saveUser(user)
        return user
    }
}

enum OnboardingError: Error {
    case invalidDisplayName
}
