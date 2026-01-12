//
//  OrbitFriendsView.swift
//  FinanceApp
//
//  Friends Orbit visualization - central pulse with friend avatars
//

import SwiftUI

struct OrbitFriendsView: View {
    let friends: [User]
    let accentColor: Color
    @State private var rotation: Double = 0

    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            let orbitRadius = min(geometry.size.width, geometry.size.height) * 0.35

            ZStack {
                // Central pulse
                PulseView(size: 80, color: accentColor)
                    .position(x: centerX, y: centerY)

                // Friend avatars orbiting
                ForEach(Array(friends.prefix(8).enumerated()), id: \.element.id) { index, friend in
                    let angle = (360.0 / Double(min(friends.count, 8))) * Double(index)
                    let adjustedAngle = angle + rotation

                    FriendAvatarView(
                        displayName: friend.displayName,
                        avatarSeed: friend.avatarSeed,
                        size: 50
                    )
                    .position(
                        x: centerX + orbitRadius * CGFloat(cos(adjustedAngle * .pi / 180)),
                        y: centerY + orbitRadius * CGFloat(sin(adjustedAngle * .pi / 180))
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 40).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Friend Avatar View
struct FriendAvatarView: View {
    let displayName: String
    let avatarSeed: String
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(DesignTokens.Colors.border, lineWidth: 2)
                )

            Text(initials)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private var initials: String {
        let words = displayName.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else {
            return String(displayName.prefix(2)).uppercased()
        }
    }

    private var gradientColors: [Color] {
        // Generate consistent colors from avatarSeed
        let hash = abs(avatarSeed.hashValue)
        let hue = Double(hash % 360) / 360.0
        return [
            Color(hue: hue, saturation: 0.6, brightness: 0.7),
            Color(hue: hue, saturation: 0.6, brightness: 0.5)
        ]
    }
}

#Preview {
    let mockFriends = [
        User(displayName: "Mina Chen", avatarSeed: "seed1"),
        User(displayName: "Alex Kim", avatarSeed: "seed2"),
        User(displayName: "Jordan Lee", avatarSeed: "seed3"),
        User(displayName: "Taylor Smith", avatarSeed: "seed4")
    ]

    return ZStack {
        DesignTokens.Colors.background.ignoresSafeArea()
        OrbitFriendsView(friends: mockFriends, accentColor: DesignTokens.Colors.accentGreen)
            .frame(height: 300)
    }
}
