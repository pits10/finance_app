//
//  PulseView.swift
//  FinanceApp
//
//  Breathing pulse animation
//

import SwiftUI

struct PulseView: View {
    let size: CGFloat
    let color: Color
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size * 1.4, height: size * 1.4)
                .blur(radius: DesignTokens.Shadows.glow)
                .scaleEffect(isPulsing ? 1.1 : 0.9)

            // Middle ring
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 2)
                .frame(width: size * 1.2, height: size * 1.2)
                .scaleEffect(isPulsing ? 1.05 : 0.95)

            // Core circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.6), color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.4), radius: DesignTokens.Shadows.glow)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        PulseView(size: 100, color: DesignTokens.Colors.accentGreen)
    }
}
