# 🚀 Setup Guide

## Prerequisites

- Flutter SDK: ^3.9.0
- Dart SDK: ^3.9.0
- Android Studio / VS Code
- Git

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd sub_tracker
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

Generate Hive type adapters and dependency injection code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Run the App

#### Android/iOS
```bash
flutter run
```

#### Web
```bash
flutter run -d chrome
```

#### Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## Development Workflow

### Code Generation

Whenever you create or modify models with Hive annotations, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting & Formatting

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/
```

### Clean Build

If you encounter issues:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

Output: `build/web/`

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test

```bash
flutter test test/path/to/test_file.dart
```

### Test Coverage

```bash
flutter test --coverage
```

## Environment Setup

### VS Code Extensions (Recommended)

- Flutter
- Dart
- Prettier
- Error Lens
- GitLens

### Android Studio Plugins (Recommended)

- Flutter
- Dart

## Troubleshooting

### Issue: Build Runner Fails

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Hive Box Errors

Delete app data and restart:
```bash
flutter clean
flutter run
```

### Issue: Dependency Conflicts

```bash
flutter pub upgrade
flutter pub get
```

### Issue: Gradle Build Fails (Android)

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

## Project Structure Overview

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core functionality
│   ├── constants/              # Constants
│   ├── di/                     # Dependency injection
│   ├── error/                  # Error handling
│   ├── network/                # API client
│   ├── router/                 # Navigation
│   ├── theme/                  # Theming
│   ├── utils/                  # Utilities
│   └── widgets/                # Shared widgets
├── data/                        # Data layer
│   ├── models/                 # Data models
│   ├── repositories/           # Repositories
│   └── datasources/            # Data sources
└── features/                    # Feature modules
    ├── subscriptions/          # Subscriptions feature
    ├── payments/               # Payments feature
    ├── analytics/              # Analytics feature
    ├── settings/               # Settings feature
    └── notifications/          # Notifications service
```

## Git Workflow

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Build/config changes

Example:
```bash
git commit -m "feat(subscriptions): add subscription list screen"
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material 3 Design](https://m3.material.io/)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)

## Support

For issues and questions, please check:
1. PROJECT_PROGRESS.md for known bugs
2. TECH_STACK.md for implementation details
3. Create an issue on GitHub

---

**Happy Coding! 🚀**
