//
//  DesignTokens.swift
//  FinanceApp
//
//  Design system tokens and color palette
//

import SwiftUI

struct DesignTokens {

    // MARK: - Colors
    struct Colors {
        // Background
        static let background = Color(hex: "0B0F14")
        static let surface = Color(hex: "111827")
        static let border = Color(hex: "1F2937")

        // Text
        static let textPrimary = Color.white.opacity(0.92)
        static let textSecondary = Color.white.opacity(0.70)
        static let textTertiary = Color.white.opacity(0.50)

        // Accents
        static let accentGreen = Color(hex: "2BFF88")
        static let accentGold = Color(hex: "FFCC66")

        // Status
        static let success = Color(hex: "2BFF88")
        static let warning = Color(hex: "FFCC66")
        static let error = Color(hex: "FF6B6B")
    }

    // MARK: - Typography
    struct Typography {
        // Sizes
        static let hero: CGFloat = 32
        static let title: CGFloat = 24
        static let headline: CGFloat = 20
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let small: CGFloat = 12

        // Weights
        static let bold: Font.Weight = .bold
        static let semibold: Font.Weight = .semibold
        static let medium: Font.Weight = .medium
        static let regular: Font.Weight = .regular
    }

    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Border Radius
    struct Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 999
    }

    // MARK: - Shadows
    struct Shadows {
        static let glow = 8.0
        static let glowOpacity = 0.4
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme-aware Accent Color
extension DesignTokens.Colors {
    static func accent(for theme: Theme) -> Color {
        switch theme {
        case .green: return accentGreen
        case .gold: return accentGold
        }
    }
}
