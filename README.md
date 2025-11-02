# Sleep Countdown

An iOS widget app that shows a countdown to your bedtime using Swift and WidgetKit.

## Overview

Sleep Countdown is a minimal iOS app with a WidgetKit extension that displays the time remaining until your configured bedtime. The app itself has minimal UI, with the main functionality living in the home screen widget.

## Features

- **Widget-First Design**: Primary interaction through home screen widgets
- **Multiple Widget Sizes**: Small, medium, and large widget options
- **iOS Settings Integration**: Configure bedtime through iOS Settings
- **Auto-Updating**: Widget refreshes every 5 minutes
- **Clean, Native Design**: Uses SwiftUI and follows iOS design guidelines

## Quick Start

1. Open `SleepCountdown.xcodeproj` in Xcode 15 or later
2. Build and run on iOS 17.0+ device or simulator
3. Configure bedtime in Settings app → Sleep Countdown
4. Add the widget to your home screen

For detailed setup instructions, see [SETUP.md](SETUP.md).

## Project Structure

- `SleepCountdown/` - Main app with minimal UI
- `SleepCountdownWidget/` - WidgetKit extension with countdown logic
- `SETUP.md` - Comprehensive setup and configuration guide

## Important Notes

### iOS Sleep Schedule Limitation

The iOS system Sleep Schedule (from Health/Clock app) is **not accessible** via any public API. This app uses UserDefaults for manual bedtime configuration. This is a platform limitation, not an implementation choice.

### Widget Installation

Widgets cannot be installed without the container app. The app must be installed first, then the widget can be added to the home screen.

## Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## License

See [LICENSE](LICENSE) for details.
