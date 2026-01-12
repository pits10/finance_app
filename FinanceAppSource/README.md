# Next Generation Finance App

**Friends × Habit × Assets**

A social habit-tracking app for investing/saving, where consistency matters more than returns. Build investing habits with friends in a calm, intelligent, premium environment—without the stress of financial comparison.

---

## 🎯 Core Concept

- **Turn investing/saving into a sustainable habit** through daily check-ins and consistency tracking
- **Solve loneliness** by making progress visible to friends
- **Social, but NOT a finance SNS**:
  - ❌ No money amounts, portfolio values, returns, P&L, or leaderboards
  - ❌ No comparison or bragging loops
  - ✅ Tickers are visible to friends
  - ✅ Progress and consistency are celebrated

### Yokune Reaction System

- "Yokune" (よくね) replaces traditional "likes" or "kudos"
- Unlimited sending—no daily limits
- Recipients see "Today's Yokune" count (private, not public)
- Designed to encourage without creating popularity contests
- One user can Yokune each activity only once (spam prevention)

---

## 🎨 Visual Design

### Design Language
- **Dark UI**: Deep charcoal background (#0B0F14), not pure black
- **Glowing accents**: Neon Green (#2BFF88) or Gold (#FFCC66)
- **Premium & Calm**: Futuristic, cinematic, intelligent
- **Subtle animations**: Pulse, glow, ripple—no loud gamification
- **English-only** UI strings

### Key Design Tokens

```swift
Background:     #0B0F14
Surface:        #111827
Border:         #1F2937
Text Primary:   rgba(255,255,255,0.92)
Text Secondary: rgba(255,255,255,0.70)
Accent Green:   #2BFF88
Accent Gold:    #FFCC66
```

---

## 📱 MVP Features

### 6 Core Screens

1. **Onboarding**
   - Display name (required)
   - Optional handle (@username)
   - Theme selection (Green/Gold)
   - Privacy mode (Balanced default)

2. **Home**
   - Today's check-in button
   - "My Raising Assets" summary
   - "Today's Yokune" count (recipient-only)

3. **Raise (Assets)**
   - List of raising assets
   - Add asset by ticker (e.g., NVDA, AAPL)
   - Tags (AI, Datacenter, Defense, Long-term, etc.)
   - Short notes (max 60 chars, no money/returns)
   - Asset levels (Lv.1–Lv.5) with stage labels

4. **Watchlist**
   - Items under consideration
   - Promote to "Raising" status
   - Ticker + tags + optional notes

5. **Friends** ⭐ **MOST IMPORTANT**
   - **Friends Orbit UI**: Central pulse with friend avatars orbiting
   - Activity feed showing:
     - "Mina checked in"
     - "Mina added NVDA to Watchlist"
     - "Mina is raising NVDA (Lv. 3)"
   - "Send Yokune" button with ripple animation
   - No public Yokune counts or rankings

6. **Add Friends**
   - Share invite code
   - Search by handle
   - Accept/decline pending requests

---

## 📊 Data Models

### User
```swift
- id: UUID
- displayName: String
- handle: String? (optional @username)
- avatarSeed: String
- theme: Theme (.green or .gold)
- privacyMode: PrivacyMode
- todaysYokuneCount: Int (computed)
```

### Friendship
```swift
- id: UUID
- userId: UUID
- friendId: UUID
- status: FriendshipStatus (.pending, .accepted, .blocked)
- createdAt: Date
```

### Asset
```swift
- id: UUID
- ticker: String
- tags: [String]
- note: String (max 60 chars)
- level: Int (1-5)
- streakCount: Int
- lastCheckinAt: Date?
```

### WatchlistItem
```swift
- id: UUID
- ticker: String
- tags: [String]
- note: String (max 60 chars)
- createdAt: Date
```

### Activity
```swift
- id: UUID
- userId: UUID
- type: ActivityType (.checkIn, .watchAdd, .raiseAdd, .raiseLevelUp)
- ticker: String? (optional)
- level: Int? (for level-up activities)
- createdAt: Date
```

### Yokune
```swift
- id: UUID
- fromUserId: UUID
- activityId: UUID
- createdAt: Date
```

---

## 🎯 Leveling System

Assets level up based on **consistency streaks**, NOT performance:

| Level | Streak Required | Stage Label      |
|-------|----------------|------------------|
| Lv. 1 | 1 day          | Beginning        |
| Lv. 2 | 3 days         | Forming          |
| Lv. 3 | 7 days         | Growing          |
| Lv. 4 | 21 days        | Strengthening    |
| Lv. 5 | 60 days        | Mastered         |

### Streak Rules
- ✅ Consecutive daily check-ins maintain streak
- ⚠️ Missed day breaks streak (gentle messaging)
- 🔄 Streak resets to 1 on break
- 📈 Level-up creates activity for friends to celebrate

---

## 🏗️ Architecture

### Technology Stack
- **SwiftUI** for UI
- **SwiftData** for local persistence
- **MVVM** architecture pattern
- **Repository pattern** for data abstraction
- **Observation framework** for reactive state management

### Project Structure

```
FinanceApp/
├── App/
│   └── FinanceAppApp.swift          # App entry point
├── Models/
│   ├── User.swift
│   ├── Friendship.swift
│   ├── Asset.swift
│   ├── WatchlistItem.swift
│   ├── Activity.swift
│   ├── Yokune.swift
│   └── Enums.swift
├── Services/
│   └── Repository/
│       ├── LocalRepository.swift     # SwiftData implementation
│       └── RemoteRepository.swift    # Stub for Supabase
├── ViewModels/
│   ├── OnboardingViewModel.swift
│   ├── HomeViewModel.swift
│   ├── RaiseViewModel.swift
│   ├── WatchlistViewModel.swift
│   ├── FriendsViewModel.swift
│   └── AddFriendsViewModel.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Raise/
│   │   └── RaiseView.swift
│   ├── Watchlist/
│   │   └── WatchlistView.swift
│   ├── Friends/
│   │   └── FriendsView.swift
│   ├── AddFriends/
│   │   └── AddFriendsView.swift
│   ├── Components/
│   │   ├── PulseView.swift          # Breathing animation
│   │   ├── OrbitFriendsView.swift   # Friends orbit visualization
│   │   ├── YokuneRipple.swift       # Yokune animation
│   │   ├── AssetCard.swift
│   │   ├── ActivityCard.swift
│   │   └── PrimaryButton.swift
│   └── MainTabView.swift             # Tab navigation
├── Design/
│   ├── DesignTokens.swift
│   └── ThemeManager.swift
└── Utilities/
    └── MockDataGenerator.swift
```

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ (for SwiftData)
- macOS Sonoma or later

### Installation & Run Steps

1. **Create Xcode Project**
   ```
   See FinanceApp/PROJECT_SETUP.md for detailed instructions
   ```

2. **Add Source Files**
   - Copy all files from `FinanceApp/FinanceApp/` to your Xcode project
   - Ensure files are added to the FinanceApp target

3. **Build and Run**
   ```
   Cmd+R or click Play button
   Select iPhone 15 Pro simulator (recommended)
   ```

4. **First Launch**
   - Complete onboarding (name, theme, privacy)
   - Mock data will auto-populate with 5 friends and sample activities
   - Check-in to start building streaks
   - Send Yokune to friends' activities

### Running with Mock Data

The app automatically populates mock data on first launch:
- ✅ 5 mock friends
- ✅ 30 sample activities
- ✅ 4 raising assets for main user
- ✅ 3 watchlist items
- ✅ Some pre-existing Yokunes

---

## 🔐 Privacy Modes

### Open
- Show all activities, tickers, and notes to friends

### Balanced (Default)
- Show activities and tickers
- Hide personal notes by default

### Private
- Show only aggregated weekly presence
- Still allow Yokune sending/receiving
- MVP: UI toggle exists, behavior simplified

---

## 📋 App Store Compliance

### ✅ Compliant
- **No investment advice** given
- **No money/returns displayed**
- **No portfolio values or P&L**
- **Privacy-first**: Doesn't collect financial data
- **Social encouragement only**: Habit tracking, not finance tracking

### Required Disclosures
- App Description: "Habit tracking app for consistent investing. Not a financial advisor."
- Privacy Policy: "We do not collect or display portfolio values, returns, or financial performance data."

---

## 🗺️ Future Roadmap

### Phase 1: Backend Integration
- [ ] Supabase setup (PostgreSQL + Auth)
- [ ] Implement RemoteRepository with Supabase client
- [ ] Real-time sync for activities and Yokunes
- [ ] Apple Sign-In integration
- [ ] Push notifications for Yokunes

### Phase 2: Social Features
- [ ] Real-time activity feed updates
- [ ] Friend recommendations
- [ ] Group challenges (optional)
- [ ] Weekly consistency reports

### Phase 3: Advanced Features
- [ ] Widgets (Today's Check-in, Yokune count)
- [ ] Apple Watch app for quick check-ins
- [ ] Siri Shortcuts integration
- [ ] iCloud sync (alternative to Supabase)

### Phase 4: Enhanced Visualization
- [ ] MomentumRing (weekly consistency visualization)
- [ ] WaveRhythm (friends vibe indicator)
- [ ] Asset growth animations
- [ ] Streak milestones and celebrations

### Phase 5: Monetization (Optional)
- [ ] Premium themes
- [ ] Custom avatar creation
- [ ] Advanced analytics (personal only, never comparative)
- [ ] Early access to new features

---

## 🛠️ Development Notes

### Key Design Decisions

1. **SwiftData over Core Data**: Modern, cleaner API, better SwiftUI integration
2. **Repository pattern**: Enables easy future backend integration
3. **Mock data on first launch**: Ensures app feels alive immediately
4. **No explicit "backend" in MVP**: Local-first, backend-ready architecture
5. **Friends Orbit UI**: Makes social connection visceral and beautiful

### Performance Considerations

- Assets are limited per user (recommend max 10-15)
- Activity feed limited to 50 most recent items
- Yokune queries optimized with indexing
- Orbit animation uses efficient geometry calculations

### Testing Strategy

- ✅ All screens have SwiftUI Previews with mock data
- ✅ Repository methods are testable
- ✅ ViewModels use dependency injection
- Future: Unit tests for business logic
- Future: UI tests for critical flows

---

## 🎨 Design System Components

### Animations
- **PulseView**: Breathing circle (2s cycle)
- **OrbitFriendsView**: Rotating friend avatars (40s full rotation)
- **YokuneRipple**: Expanding ripples on Yokune send (1.2s duration)

### UI Components
- **AssetCard**: Ticker + Level + Tags
- **ActivityCard**: User avatar + Activity text + Yokune button
- **PrimaryButton**: Glowing accent button
- **SecondaryButton**: Outlined button
- **TagChip**: Selectable tag bubble
- **EmptyStateView**: Consistent empty state messaging

---

## 📄 License

Proprietary - All Rights Reserved

---

## 🙏 Acknowledgments

Inspired by the best of:
- **Monzo/Revolut**: Premium fintech UX
- **Robinhood**: Accessible investing
- **Duolingo**: Habit-forming streaks
- **BeReal**: Anti-performative social

Built with ❤️ for people who want to build investing habits sustainably, together.

---

## 📧 Support

For issues or questions during development:
1. Check FinanceApp/PROJECT_SETUP.md for setup issues
2. Review architecture documentation above
3. Examine SwiftUI Previews for component examples

---

**Ready to build the future of social habit tracking? Let's go! 🚀**
