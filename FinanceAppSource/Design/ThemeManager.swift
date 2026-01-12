//
//  ThemeManager.swift
//  FinanceApp
//
//  Global theme manager
//

import SwiftUI
import Observation

@Observable
final class ThemeManager {
    var currentTheme: Theme = .green

    var accentColor: Color {
        DesignTokens.Colors.accent(for: currentTheme)
    }

    func setTheme(_ theme: Theme) {
        currentTheme = theme
    }
}
