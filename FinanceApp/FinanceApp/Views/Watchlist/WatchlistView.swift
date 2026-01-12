//
//  WatchlistView.swift
//  FinanceApp
//
//  Watchlist screen
//

import SwiftUI

struct WatchlistView: View {
    @State private var viewModel: WatchlistViewModel
    let themeManager: ThemeManager

    init(repository: LocalRepository, themeManager: ThemeManager) {
        self._viewModel = State(initialValue: WatchlistViewModel(repository: repository))
        self.themeManager = themeManager
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DesignTokens.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                Text("Watchlist")
                                    .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                                    .foregroundColor(DesignTokens.Colors.textPrimary)

                                Text("\(viewModel.watchlistItems.count) items")
                                    .font(.system(size: DesignTokens.Typography.body))
                                    .foregroundColor(DesignTokens.Colors.textSecondary)
                            }

                            Spacer()

                            Button(action: {
                                viewModel.showingAddItem = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(themeManager.accentColor)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.lg)

                        // Watchlist Items
                        if viewModel.watchlistItems.isEmpty {
                            EmptyStateView(
                                icon: "eye.circle",
                                title: "No watchlist items",
                                message: "Add items you're considering"
                            )
                            .padding(.top, DesignTokens.Spacing.xxl)
                        } else {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                ForEach(viewModel.watchlistItems, id: \.id) { item in
                                    WatchlistItemRow(
                                        item: item,
                                        accentColor: themeManager.accentColor,
                                        onPromote: {
                                            viewModel.promoteToRaising(item)
                                        },
                                        onDelete: {
                                            viewModel.deleteWatchlistItem(item)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, DesignTokens.Spacing.lg)
                        }

                        Spacer()
                            .frame(height: DesignTokens.Spacing.xl)
                    }
                }
                .sheet(isPresented: $viewModel.showingAddItem) {
                    AddWatchlistItemSheet(viewModel: viewModel, accentColor: themeManager.accentColor)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

// MARK: - Watchlist Item Row
struct WatchlistItemRow: View {
    let item: WatchlistItem
    let accentColor: Color
    let onPromote: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // Header
            HStack {
                Text(item.ticker)
                    .font(.system(size: DesignTokens.Typography.title, weight: .bold))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(DesignTokens.Colors.textTertiary)
                }
            }

            // Tags
            if !item.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: DesignTokens.Typography.small))
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                                .padding(.horizontal, DesignTokens.Spacing.sm)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                        .fill(DesignTokens.Colors.surface)
                                )
                        }
                    }
                }
            }

            // Note
            if !item.note.isEmpty {
                Text(item.note)
                    .font(.system(size: DesignTokens.Typography.body))
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                    .lineLimit(2)
            }

            // Promote Button
            SecondaryButton(
                title: "Promote to Raising",
                accentColor: accentColor,
                action: onPromote
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
    }
}

// MARK: - Add Watchlist Item Sheet
struct AddWatchlistItemSheet: View {
    @ObservedObject var viewModel: WatchlistViewModel
    let accentColor: Color
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                DesignTokens.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        // Ticker
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("Ticker")
                                .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                                .foregroundColor(DesignTokens.Colors.textSecondary)

                            TextField("AAPL, NVDA, BTC...", text: $viewModel.newTicker)
                                .font(.system(size: DesignTokens.Typography.body))
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                                .textInputAutocapitalization(.characters)
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

                        // Note
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            HStack {
                                Text("Note")
                                    .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                                    .foregroundColor(DesignTokens.Colors.textSecondary)

                                Spacer()

                                Text("\(viewModel.newNote.count)/60")
                                    .font(.system(size: DesignTokens.Typography.small))
                                    .foregroundColor(DesignTokens.Colors.textTertiary)
                            }

                            TextField("Why are you watching this?", text: $viewModel.newNote, axis: .vertical)
                                .font(.system(size: DesignTokens.Typography.body))
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                                .lineLimit(2...4)
                                .padding(DesignTokens.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                        .fill(DesignTokens.Colors.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                                .stroke(DesignTokens.Colors.border, lineWidth: 1)
                                        )
                                )
                                .onChange(of: viewModel.newNote) { _, newValue in
                                    if newValue.count > 60 {
                                        viewModel.newNote = String(newValue.prefix(60))
                                    }
                                }
                        }

                        // Tags
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("Tags")
                                .font(.system(size: DesignTokens.Typography.caption, weight: .medium))
                                .foregroundColor(DesignTokens.Colors.textSecondary)

                            FlowLayout(spacing: DesignTokens.Spacing.xs) {
                                ForEach(viewModel.availableTags, id: \.self) { tag in
                                    TagChip(
                                        tag: tag,
                                        isSelected: viewModel.selectedTags.contains(tag),
                                        accentColor: accentColor,
                                        action: {
                                            viewModel.toggleTag(tag)
                                        }
                                    )
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(DesignTokens.Spacing.lg)
                }
            }
            .navigationTitle("Add to Watchlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addWatchlistItem()
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                    .disabled(viewModel.newTicker.isEmpty)
                }
            }
            .toolbarBackground(DesignTokens.Colors.background, for: .navigationBar)
        }
    }
}
