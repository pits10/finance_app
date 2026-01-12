//
//  YokuneRipple.swift
//  FinanceApp
//
//  Yokune ripple animation effect
//

import SwiftUI

struct YokuneRipple: View {
    let color: Color
    @State private var animating = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(color.opacity(0.4), lineWidth: 2)
                    .scaleEffect(animating ? 2 : 0.5)
                    .opacity(animating ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.2)
                        .delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .frame(width: 60, height: 60)
        .onAppear {
            animating = true
        }
    }
}

// MARK: - Yokune Button with Ripple
struct YokuneButton: View {
    let accentColor: Color
    let hasYokuned: Bool
    let action: () -> Void

    @State private var showRipple = false

    var body: some View {
        Button(action: {
            if !hasYokuned {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showRipple = true
                }
                action()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showRipple = false
                }
            }
        }) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: hasYokuned ? "checkmark.circle.fill" : "hand.thumbsup")
                    .font(.system(size: 16))
                Text(hasYokuned ? "Sent" : "Send Yokune")
                    .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
            }
            .foregroundColor(hasYokuned ? DesignTokens.Colors.textTertiary : accentColor)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .fill(hasYokuned ? DesignTokens.Colors.surface : accentColor.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                            .stroke(hasYokuned ? DesignTokens.Colors.border : accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .overlay(
                showRipple ? YokuneRipple(color: accentColor) : nil
            )
        }
        .disabled(hasYokuned)
    }
}

#Preview {
    ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        VStack(spacing: 20) {
            YokuneButton(
                accentColor: DesignTokens.Colors.accentGreen,
                hasYokuned: false,
                action: {}
            )
            YokuneButton(
                accentColor: DesignTokens.Colors.accentGreen,
                hasYokuned: true,
                action: {}
            )
        }
    }
}
