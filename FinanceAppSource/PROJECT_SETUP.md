# Xcode Project Setup Guide

This guide will help you set up the Xcode project for the Finance App.

## Step 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Select "iOS" → "App"
4. Configure the project:
   - Product Name: `FinanceApp`
   - Team: (Your development team)
   - Organization Identifier: `com.yourcompany`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **SwiftData** (Important!)
   - Include Tests: ✓ (Optional)

## Step 2: Add Source Files

1. Delete the default `ContentView.swift` and `Item.swift` files that Xcode creates
2. In Finder, locate your Xcode project folder
3. Copy all folders from `FinanceApp/FinanceApp/` into the Xcode project:
   - App/
   - Models/
   - Services/
   - ViewModels/
   - Views/
   - Design/
   - Utilities/

4. In Xcode, right-click on the `FinanceApp` group → "Add Files to FinanceApp"
5. Select all the copied folders and ensure:
   - ✓ Copy items if needed
   - ✓ Create groups
   - ✓ Add to target: FinanceApp

## Step 3: Configure Project Settings

### Info.plist Additions

Add these keys if needed:

```xml
<key>UIUserInterfaceStyle</key>
<string>Dark</string>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

### Deployment Target

- Set minimum iOS deployment target to **iOS 17.0** or later (for SwiftData)

### App Icon

1. Create an app icon (optional for MVP)
2. Assets.xcassets → AppIcon

## Step 4: Build and Run

1. Select a simulator (iPhone 15 Pro recommended)
2. Press Cmd+R or click the Play button
3. The app should compile and run successfully

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Clean Build Folder: Cmd+Shift+K
2. Restart Xcode
3. Delete Derived Data: Xcode → Preferences → Locations → Derived Data → Delete
4. Ensure all files are properly added to the target

### SwiftData Issues

- Make sure you selected "SwiftData" when creating the project
- Verify iOS deployment target is 17.0+
- Check that all model files use `@Model` macro correctly

### Preview Errors

- Previews require all dependencies to be properly configured
- Some previews use mock data and should work out of the box
- If previews fail, try building for device/simulator first

## Next Steps

Once the project builds successfully:

1. Run the app on simulator
2. Complete onboarding to create your profile
3. Explore all 6 screens: Home, Raise, Watchlist, Friends, Add Friends
4. Mock data will be automatically populated on first launch
5. Test check-in functionality and Yokune reactions

Enjoy building with the Next Generation Finance App! 🚀
