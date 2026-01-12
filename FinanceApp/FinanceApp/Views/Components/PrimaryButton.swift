//
//  PrimaryButton.swift
//  FinanceApp
//
//  Primary action button
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let accentColor: Color
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: DesignTokens.Typography.body, weight: .semibold))
                .foregroundColor(isEnabled ? .black : DesignTokens.Colors.textTertiary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(isEnabled ? accentColor : DesignTokens.Colors.surface)
                        .shadow(
                            color: isEnabled ? accentColor.opacity(0.3) : .clear,
                            radius: DesignTokens.Shadows.glow
                        )
                )
        }
        .disabled(!isEnabled)
    }
}

struct SecondaryButton: View {
    let title: String
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: DesignTokens.Typography.body, weight: .medium))
                .foregroundColor(accentColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .stroke(accentColor.opacity(0.5), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                .fill(accentColor.opacity(0.1))
                        )
                )
        }
    }
}

#Preview {
    ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            PrimaryButton(
                title: "Continue",
                accentColor: DesignTokens.Colors.accentGreen,
                action: {}
            )
            SecondaryButton(
                title: "Skip",
                accentColor: DesignTokens.Colors.accentGreen,
                action: {}
            )
        }
        .padding()
    }
}
