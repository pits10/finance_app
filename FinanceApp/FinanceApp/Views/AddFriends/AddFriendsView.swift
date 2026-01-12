//
//  AddFriendsView.swift
//  FinanceApp
//
//  Add Friends screen
//

import SwiftUI

struct AddFriendsView: View {
    @State private var viewModel: AddFriendsViewModel
    let themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    init(repository: LocalRepository, themeManager: ThemeManager) {
        self._viewModel = State(initialValue: AddFriendsViewModel(repository: repository))
        self.themeManager = themeManager
    }

    var body: some View {
        ZStack {
            DesignTokens.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // Invite Code Section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Your Invite Code")
                            .font(.system(size: DesignTokens.Typography.headline, weight: .semibold))
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Text("Share this code with friends to connect")
                            .font(.system(size: DesignTokens.Typography.body))
                            .foregroundColor(DesignTokens.Colors.textSecondary)

                        HStack {
                            Text(viewModel.inviteCode)
                                .font(.system(size: DesignTokens.Typography.title, weight: .bold))
                                .foregroundColor(themeManager.accentColor)
                                .padding(DesignTokens.Spacing.md)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                        .fill(themeManager.accentColor.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                                .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                                        )
                                )

                            Button(action: {
                                UIPasteboard.general.string = viewModel.inviteCode
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 20))
                                    .foregroundColor(themeManager.accentColor)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                            .fill(themeManager.accentColor.opacity(0.1))
                                    )
                            }
                        }

                        SecondaryButton(
                            title: "Share Invite Code",
                            accentColor: themeManager.accentColor,
                            action: {
                                shareInviteCode()
                            }
                        )
                    }
                    .padding(DesignTokens.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .fill(DesignTokens.Colors.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                    .stroke(DesignTokens.Colors.border, lineWidth: 1)
                            )
                    )

                    Divider()
                        .background(DesignTokens.Colors.border)

                    // Search by Handle
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Search by Handle")
                            .font(.system(size: DesignTokens.Typography.headline, weight: .semibold))
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        HStack {
                            TextField("@username", text: $viewModel.searchHandle)
                                .font(.system(size: DesignTokens.Typography.body))
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                                .textInputAutocapitalization(.never)
                                .padding(DesignTokens.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                        .fill(DesignTokens.Colors.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                                .stroke(DesignTokens.Colors.border, lineWidth: 1)
                                        )
                                )

                            Button(action: {
                                viewModel.searchUser()
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20))
                                    .foregroundColor(themeManager.accentColor)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                            .fill(themeManager.accentColor.opacity(0.1))
                                    )
                            }
                        }

                        // Search Result
                        if let result = viewModel.searchResult {
                            UserSearchResult(
                                user: result,
                                accentColor: themeManager.accentColor,
                                onAdd: {
                                    viewModel.sendFriendRequest(to: result)
                                }
                            )
                        } else if !viewModel.searchHandle.isEmpty && !viewModel.isSearching {
                            Text("No user found")
                                .font(.system(size: DesignTokens.Typography.body))
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(DesignTokens.Spacing.lg)
                        }
                    }

                    // Pending Requests
                    if !viewModel.pendingRequests.isEmpty {
                        Divider()
                            .background(DesignTokens.Colors.border)

                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            Text("Pending Requests")
                                .font(.system(size: DesignTokens.Typography.headline, weight: .semibold))
                                .foregroundColor(DesignTokens.Colors.textPrimary)

                            ForEach(Array(zip(viewModel.pendingRequests, viewModel.pendingUsers)), id: \.0.id) { friendship, user in
                                PendingRequestRow(
                                    user: user,
                                    friendship: friendship,
                                    accentColor: themeManager.accentColor,
                                    onAccept: {
                                        viewModel.acceptFriendRequest(friendship)
                                    },
                                    onDecline: {
                                        viewModel.declineFriendRequest(friendship)
                                    }
                                )
                            }
                        }
                    }

                    Spacer()
                        .frame(height: DesignTokens.Spacing.xl)
                }
                .padding(DesignTokens.Spacing.lg)
            }
        }
        .navigationTitle("Add Friends")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignTokens.Colors.background, for: .navigationBar)
        .onAppear {
            viewModel.loadData()
        }
    }

    private func shareInviteCode() {
        let items = ["Join me on Next Gen Finance! Use invite code: \(viewModel.inviteCode)"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - User Search Result
struct UserSearchResult: View {
    let user: User
    let accentColor: Color
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            FriendAvatarView(
                displayName: user.displayName,
                avatarSeed: user.avatarSeed,
                size: 50
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName)
                    .font(.system(size: DesignTokens.Typography.body, weight: .semibold))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                if let handle = user.handle {
                    Text("@\(handle)")
                        .font(.system(size: DesignTokens.Typography.caption))
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }
            }

            Spacer()

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(accentColor)
            }
        }
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
}

// MARK: - Pending Request Row
struct PendingRequestRow: View {
    let user: User
    let friendship: Friendship
    let accentColor: Color
    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            HStack(spacing: DesignTokens.Spacing.md) {
                FriendAvatarView(
                    displayName: user.displayName,
                    avatarSeed: user.avatarSeed,
                    size: 50
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.displayName)
                        .font(.system(size: DesignTokens.Typography.body, weight: .semibold))
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    if let handle = user.handle {
                        Text("@\(handle)")
                            .font(.system(size: DesignTokens.Typography.caption))
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }

                Spacer()
            }

            HStack(spacing: DesignTokens.Spacing.sm) {
                Button(action: onAccept) {
                    Text("Accept")
                        .font(.system(size: DesignTokens.Typography.body, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                .fill(accentColor)
                        )
                }

                Button(action: onDecline) {
                    Text("Decline")
                        .font(.system(size: DesignTokens.Typography.body, weight: .medium))
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                .stroke(DesignTokens.Colors.border, lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                        .fill(DesignTokens.Colors.surface)
                                )
                        )
                }
            }
        }
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
}
