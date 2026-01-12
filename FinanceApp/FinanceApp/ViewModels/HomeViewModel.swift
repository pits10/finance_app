//
//  HomeViewModel.swift
//  FinanceApp
//
//  Home screen view model
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    var currentUser: User?
    var raisingAssets: [Asset] = []
    var todaysYokuneCount: Int = 0
    var hasCheckedInToday: Bool = false

    private let repository: LocalRepository

    init(repository: LocalRepository) {
        self.repository = repository
        loadData()
    }

    func loadData() {
        currentUser = repository.fetchCurrentUser()
        guard let user = currentUser else { return }

        raisingAssets = repository.fetchAssets(for: user.id)
        todaysYokuneCount = repository.fetchTodaysYokuneCount(for: user.id)
        hasCheckedInToday = checkIfCheckedInToday()
    }

    func performCheckIn() {
        guard let user = currentUser else { return }

        do {
            let activities = try repository.performCheckIn(for: user)
            hasCheckedInToday = true
            loadData() // Reload to get updated assets
            print("✅ Check-in completed. Created \(activities.count) activities.")
        } catch {
            print("❌ Check-in failed: \(error)")
        }
    }

    private func checkIfCheckedInToday() -> Bool {
        guard let user = currentUser else { return false }

        let activities = repository.fetchActivities(for: [user.id], limit: 10)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return activities.contains { activity in
            activity.type == .checkIn && activity.createdAt >= today
        }
    }
}
