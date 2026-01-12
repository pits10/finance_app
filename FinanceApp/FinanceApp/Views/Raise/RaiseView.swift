//
//  RaiseView.swift
//  FinanceApp
//
//  Raise (Assets) screen
//

import SwiftUI

struct RaiseView: View {
    @State private var viewModel: RaiseViewModel
    let themeManager: ThemeManager

    init(repository: LocalRepository, themeManager: ThemeManager) {
        self._viewModel = State(initialValue: RaiseViewModel(repository: repository))
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
                                Text("Raising")
                                    .font(.system(size: DesignTokens.Typography.hero, weight: .bold))
                                    .foregroundColor(DesignTokens.Colors.textPrimary)

                                Text("\(viewModel.raisingAssets.count) assets")
                                    .font(.system(size: DesignTokens.Typography.body))
                                    .foregroundColor(DesignTokens.Colors.textSecondary)
                            }

                            Spacer()

                            Button(action: {
                                viewModel.showingAddAsset = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(themeManager.accentColor)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.lg)

                        // Assets List
                        if viewModel.raisingAssets.isEmpty {
                            EmptyStateView(
                                icon: "arrow.up.circle",
                                title: "No raising assets",
                                message: "Start raising your first asset"
                            )
                            .padding(.top, DesignTokens.Spacing.xxl)
                        } else {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                ForEach(viewModel.raisingAssets, id: \.id) { asset in
                                    RaiseAssetRow(asset: asset, accentColor: themeManager.accentColor) {
                                        viewModel.deleteAsset(asset)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignTokens.Spacing.lg)
                        }

                        Spacer()
                            .frame(height: DesignTokens.Spacing.xl)
                    }
                }
                .sheet(isPresented: $viewModel.showingAddAsset) {
                    AddAssetSheet(viewModel: viewModel, accentColor: themeManager.accentColor)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

// MARK: - Raise Asset Row
struct RaiseAssetRow: View {
    let asset: Asset
    let accentColor: Color
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.ticker)
                        .font(.system(size: DesignTokens.Typography.title, weight: .bold))
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    HStack(spacing: DesignTokens.Spacing.sm) {
                        // Level badge
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text(asset.assetLevel.displayName)
                                .font(.system(size: DesignTokens.Typography.small, weight: .semibold))
                        }
                        .foregroundColor(accentColor)
                        .padding(.horizontal, DesignTokens.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                .fill(accentColor.opacity(0.15))
                        )

                        Text(asset.assetLevel.stageLabel)
                            .font(.system(size: DesignTokens.Typography.small))
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(DesignTokens.Colors.textTertiary)
                }
            }

            // Streak info
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14))
                    .foregroundColor(accentColor)

                Text("\(asset.streakCount) day streak")
                    .font(.system(size: DesignTokens.Typography.body, weight: .medium))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                if !asset.isStreakActive {
                    Text("• Inactive")
                        .font(.system(size: DesignTokens.Typography.small))
                        .foregroundColor(DesignTokens.Colors.warning)
                }
            }

            // Tags
            if !asset.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach(asset.tags, id: \.self) { tag in
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
            if !asset.note.isEmpty {
                Text(asset.note)
                    .font(.system(size: DesignTokens.Typography.body))
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                    .lineLimit(2)
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

// MARK: - Add Asset Sheet
struct AddAssetSheet: View {
    @Bindable var viewModel: RaiseViewModel
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

                            TextField("Why are you raising this?", text: $viewModel.newNote, axis: .vertical)
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
            .navigationTitle("Add Asset")
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
                        viewModel.addAsset()
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

// MARK: - Tag Chip
struct TagChip: View {
    let tag: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.system(size: DesignTokens.Typography.small, weight: .medium))
                .foregroundColor(isSelected ? .black : DesignTokens.Colors.textSecondary)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                        .fill(isSelected ? accentColor : DesignTokens.Colors.surface)
                )
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
