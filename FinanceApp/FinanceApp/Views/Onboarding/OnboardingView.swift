//
//  OnboardingView.swift
//  FinanceApp
//
//  Onboarding flow
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel: OnboardingViewModel
    @Binding var isOnboardingComplete: Bool
    let repository: LocalRepository
    let themeManager: ThemeManager

    init(isOnboardingComplete: Binding<Bool>, repository: LocalRepository, themeManager: ThemeManager) {
        self._isOnboardingComplete = isOnboardingComplete
        self.repository = repository
        self.themeManager = themeManager
        self._viewModel = State(initialValue: OnboardingViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            DesignTokens.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    Spacer()
                        .frame(height: DesignTokens.Spacing.xxl)

                    // Title
                    VStack(spacing: DesignTokens.Spacing.md) {
                        Text("Next Generation")
                            .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Text("Finance App")
                            .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                            .foregroundColor(themeManager.accentColor)

                        Text("Build investing habits with friends")
                            .font(.system(size: DesignTokens.Typography.body))
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, DesignTokens.Spacing.sm)
                    }

                    Spacer()
                        .frame(height: DesignTokens.Spacing.xl)

                    // Display Name
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Display Name")
                            .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.textSecondary)

                        TextField("Your name", text: $viewModel.displayName)
                            .font(.system(size: DesignTokens.Typography.body))
                            .foregroundColor(DesignTokens.Colors.textPrimary)
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

                    // Handle (optional)
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Handle (optional)")
                            .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.textSecondary)

                        TextField("@username", text: $viewModel.handle)
                            .font(.system(size: DesignTokens.Typography.body))
                            .foregroundColor(DesignTokens.Colors.textPrimary)
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

                    // Theme Selection
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Theme")
                            .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.textSecondary)

                        HStack(spacing: DesignTokens.Spacing.md) {
                            ForEach(Theme.allCases, id: \.self) { theme in
                                ThemeOption(
                                    theme: theme,
                                    isSelected: viewModel.selectedTheme == theme,
                                    action: {
                                        viewModel.selectedTheme = theme
                                        themeManager.setTheme(theme)
                                    }
                                )
                            }
                        }
                    }

                    // Privacy Mode
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Privacy Mode")
                            .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.textSecondary)

                        VStack(spacing: DesignTokens.Spacing.sm) {
                            ForEach(PrivacyMode.allCases, id: \.self) { mode in
                                PrivacyModeOption(
                                    mode: mode,
                                    isSelected: viewModel.selectedPrivacyMode == mode,
                                    action: {
                                        viewModel.selectedPrivacyMode = mode
                                    }
                                )
                            }
                        }
                    }

                    Spacer()
                        .frame(height: DesignTokens.Spacing.xl)

                    // Continue Button
                    PrimaryButton(
                        title: "Continue",
                        accentColor: themeManager.accentColor,
                        action: {
                            completeOnboarding()
                        },
                        isEnabled: viewModel.isDisplayNameValid
                    )
                }
                .padding(DesignTokens.Spacing.lg)
            }
        }
    }

    private func completeOnboarding() {
        do {
            _ = try viewModel.completeOnboarding()
            isOnboardingComplete = true
        } catch {
            print("❌ Onboarding failed: \(error)")
        }
    }
}

// MARK: - Theme Option
struct ThemeOption: View {
    let theme: Theme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                Circle()
                    .fill(themeColor)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? themeColor : DesignTokens.Colors.border, lineWidth: 3)
                    )
                    .shadow(color: isSelected ? themeColor.opacity(0.4) : .clear, radius: DesignTokens.Shadows.glow)

                Text(theme.displayName)
                    .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                    .foregroundColor(isSelected ? DesignTokens.Colors.textPrimary : DesignTokens.Colors.textSecondary)
            }
        }
    }

    private var themeColor: Color {
        switch theme {
        case .green: return DesignTokens.Colors.accentGreen
        case .gold: return DesignTokens.Colors.accentGold
        }
    }
}

// MARK: - Privacy Mode Option
struct PrivacyModeOption: View {
    let mode: PrivacyMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? DesignTokens.Colors.accentGreen : DesignTokens.Colors.textTertiary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.system(size: DesignTokens.Typography.body, weight: .medium))
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    Text(mode.description)
                        .font(.system(size: DesignTokens.Typography.small))
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(isSelected ? DesignTokens.Colors.surface : DesignTokens.Colors.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .stroke(isSelected ? DesignTokens.Colors.accentGreen.opacity(0.3) : DesignTokens.Colors.border, lineWidth: 1)
                    )
            )
        }
    }
}
