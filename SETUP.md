# Sleep Countdown Widget - Setup Guide

This is a Swift iOS widget app prototype using WidgetKit for countdown before bedtime.

## Features

- **Widget-First Design**: The main functionality is in the widget, with minimal app UI
- **Countdown Timer**: Shows time remaining until your configured bedtime
- **Multiple Widget Sizes**: Supports small, medium, and large widget sizes
- **iOS Settings Integration**: Configure bedtime through iOS Settings (via UserDefaults)
- **Auto-Updating**: Widget refreshes every 5 minutes to keep countdown accurate

## Project Structure

```
SleepCountdown/
├── SleepCountdown.xcodeproj/          # Xcode project file
├── SleepCountdown/                     # Main app target
│   ├── SleepCountdownApp.swift        # Main app entry point
│   ├── Assets.xcassets/               # App assets
│   ├── Info.plist                     # App configuration
│   └── SleepCountdown.entitlements    # App entitlements
└── SleepCountdownWidget/              # Widget extension
    ├── SleepCountdownWidget.swift     # Widget implementation
    ├── Assets.xcassets/               # Widget assets
    └── Info.plist                     # Widget configuration
```

## Requirements

- Xcode 15.0 or later
- iOS 17.0 or later
- Swift 5.9 or later

## Building the App

### Option 1: Using Xcode

1. Open `SleepCountdown.xcodeproj` in Xcode
2. Select your development team in the project settings:
   - Select the project in the navigator
   - Go to "Signing & Capabilities" tab
   - Select your team for both targets: `SleepCountdown` and `SleepCountdownWidgetExtension`
3. Select a simulator or connected device
4. Press `Cmd + R` to build and run

### Option 2: Using Command Line

```bash
# Build the project
xcodebuild -project SleepCountdown.xcodeproj \
  -scheme SleepCountdown \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Run on simulator (requires simulator to be running)
xcrun simctl install booted <path-to-built-app>
xcrun simctl launch booted com.example.SleepCountdown
```

## Configuring Bedtime

Since iOS doesn't provide API access to the system Sleep Schedule, bedtime is configured via UserDefaults:

### Method 1: Through App Settings

The app provides a button to open iOS Settings where you can configure app-specific settings.

### Method 2: Programmatically (for testing)

You can set bedtime values using UserDefaults in the app or a test script:

```swift
let defaults = UserDefaults(suiteName: "group.com.example.SleepCountdown") ?? UserDefaults.standard
defaults.set(22, forKey: "bedtimeHour")    // 10 PM
defaults.set(30, forKey: "bedtimeMinute")  // 30 minutes
```

### Method 3: Via xcrun (for simulator testing)

```bash
xcrun simctl spawn booted defaults write com.example.SleepCountdown bedtimeHour 22
xcrun simctl spawn booted defaults write com.example.SleepCountdown bedtimeMinute 30
```

## Adding the Widget to Home Screen

1. Install and run the app on your device/simulator
2. Long-press on the home screen to enter edit mode
3. Tap the "+" button in the top-left corner
4. Search for "Sleep Countdown"
5. Select your preferred widget size (Small, Medium, or Large)
6. Tap "Add Widget"
7. Position the widget and tap "Done"

## Widget Behavior

- **Default Bedtime**: If not configured, defaults to 10:00 PM (22:00)
- **Update Frequency**: Updates every 5 minutes
- **Timeline**: Generates entries for the next 24 hours
- **Countdown Format**:
  - More than 1 hour: "Xh Ym" (e.g., "2h 30m")
  - Less than 1 hour: "Ym" (e.g., "45m")
  - At bedtime: "Bedtime now!"
  - Past bedtime: "Past bedtime"

## Limitations & Known Issues

### iOS Sleep Schedule Integration

**Important**: The iOS Sleep Schedule (bedtime/wake time set in the Health app or Clock app) is **not accessible** via any public API. This includes:
- HealthKit does not expose sleep schedule data
- The sleep schedule is part of iOS Focus system with very limited access
- Only actual sleep analysis data (recorded sleep) is available through HealthKit

**Current Solution**: The app uses UserDefaults for manual bedtime configuration. This is a limitation of iOS platform, not the implementation.

**Future Possibilities**:
- Manual bedtime sync with Health app (user would need to input the same bedtime)
- Integration with actual sleep tracking data (if user grants HealthKit permissions)
- Shortcuts integration to allow easier bedtime updates

### Widget-Only Installation

**Note**: iOS requires the container app to be installed before the widget can be used. It's not possible to install a widget without the app, as widgets are extensions of the main app bundle.

## Customization

### Changing Widget Appearance

Edit `SleepCountdownWidget.swift` to customize:
- Colors: Modify `.foregroundColor()` values
- Icons: Change `Image(systemName:)` to use different SF Symbols
- Layout: Adjust spacing, padding, and font sizes
- Text: Update labels and descriptions

### Adding More Widget Families

The widget currently supports:
- `systemSmall`
- `systemMedium`
- `systemLarge`

Additional families can be added by:
1. Adding the family to `.supportedFamilies()` in the widget configuration
2. Creating a new view case in `SleepCountdownWidgetView`

### Integration with HealthKit (Future Enhancement)

To integrate with HealthKit for sleep tracking:
1. Enable HealthKit capability in Xcode
2. Request authorization for sleep analysis
3. Query `HKCategoryTypeIdentifierSleepAnalysis` for historical sleep data
4. Use the data to suggest optimal bedtime based on sleep patterns

## Troubleshooting

### Widget Not Appearing
- Ensure the app is installed and has been opened at least once
- Check that the widget extension target is included in the build
- Restart the device/simulator

### Countdown Not Updating
- Check that the bedtime is set correctly in UserDefaults
- Ensure the widget has permission to update (check Background App Refresh settings)
- Force-refresh the widget by removing and re-adding it

### Build Errors
- Verify Xcode version is 15.0 or later
- Check that all files are included in the correct target
- Clean build folder (Cmd + Shift + K) and rebuild

## Contributing

This is a prototype implementation. Potential improvements:
- iOS Settings bundle for easier bedtime configuration
- Shortcuts integration
- Multiple bedtime profiles (weekday/weekend)
- Sleep quality tracking integration
- Dark mode optimization
- Accessibility improvements

## License

See LICENSE file for details.
