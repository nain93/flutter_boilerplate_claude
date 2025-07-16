# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a standard Flutter application boilerplate project created with the default Flutter template. It contains a basic counter app with Material Design components.

## Development Commands

### Running the App
```bash
flutter run
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Building
```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for web
flutter build web
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade
```

## Project Structure

- `lib/main.dart` - Entry point containing MyApp and MyHomePage widgets
- `test/widget_test.dart` - Basic widget test for the counter functionality
- `pubspec.yaml` - Project dependencies and configuration
- `analysis_options.yaml` - Dart analyzer configuration with flutter_lints

## Architecture

This is a basic Flutter app with:
- **Material Design**: Uses MaterialApp with default theme
- **State Management**: Uses built-in StatefulWidget with setState()
- **Entry Point**: Single main.dart file with MyApp root widget
- **Testing**: Standard flutter_test setup for widget testing

## Dependencies

- **flutter**: Core Flutter SDK
- **cupertino_icons**: iOS-style icons
- **flutter_lints**: Linting rules for code quality

## Key Files

- `lib/main.dart:13` - MaterialApp configuration with theme
- `lib/main.dart:38` - MyHomePage StatefulWidget with counter logic
- `test/widget_test.dart:14` - Counter increment test