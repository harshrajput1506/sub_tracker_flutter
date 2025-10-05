# 🛠️ Tech Stack & Implementation Notes

## 📚 Libraries & Packages

### **State Management**
- **flutter_bloc (9.1.1)** - BLoC pattern for state management
- **equatable (2.0.7)** - Value equality for models and states

### **Local Storage**
- **hive (2.2.3)** - Fast, lightweight NoSQL database
- **hive_flutter (1.1.0)** - Hive integration for Flutter
- **hive_generator (2.0.1)** - Code generation for Hive adapters

### **Networking**
- **dio (5.9.0)** - HTTP client for API requests
- **dio_web_adapter (2.1.1)** - Web support for Dio

### **Routing**
- **go_router (16.2.4)** - Declarative routing with deep linking support

### **Dependency Injection**
- **get_it (8.2.0)** - Service locator for dependency injection
- **injectable (2.5.2)** - Code generation for dependency injection
- **injectable_generator (2.6.2)** - Generator for injectable

### **Error Handling**
- **dartz (0.10.1)** - Functional programming (Either for error handling)

### **Utilities**
- **logger (2.6.1)** - Beautiful logs for debugging
- **google_fonts** - Custom fonts integration

### **Notifications**
- **flutter_local_notifications (19.4.2)** - Local push notifications

### **Charts & Analytics**
- **fl_chart (1.1.1)** - Beautiful charts for analytics

### **Code Generation**
- **build_runner (2.4.13)** - Code generation tool

---

## 🎨 App Theme & Styling

### **Design System**
- **Material 3 (Material You)** - Modern Material Design
- **Color Scheme**: Dynamic color generation with seed colors
- **Typography**: Google Fonts (Raleway) with custom text themes
- **Theme Modes**: Light & Dark themes with system preference support

### **Theme Structure**
```dart
lib/core/theme/
├── app_theme.dart          // Theme configuration
├── app_colors.dart         // Color palette
├── app_text_styles.dart    // Typography styles
└── theme_cubit.dart        // Theme state management
```

### **Color Palette**
- **Primary**: Material blue shades
- **Secondary**: Accent colors for highlights
- **Surface**: Background and card colors
- **Error**: Red shades for error states
- **Neutral**: Grey shades for text and borders

### **Spacing System**
- **XXS**: 4px
- **XS**: 8px
- **SM**: 12px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px
- **XXL**: 48px

### **Border Radius**
- **Small**: 8px
- **Medium**: 12px
- **Large**: 16px
- **XLarge**: 24px

---

## 🧩 Shared Widgets

All shared widgets are located in `lib/core/widgets/` with consistent styling:

### **Form Widgets**
- **CustomTextField** - Styled text input with validation
- **CustomDropdown** - Dropdown selector with search
- **CustomDatePicker** - Date selection widget
- **CustomButton** - Primary/Secondary/Outlined buttons

### **Display Widgets**
- **CustomCard** - Container with elevation and padding
- **CustomChip** - Category/tag chips
- **EmptyState** - Empty list placeholder
- **LoadingIndicator** - Consistent loading spinner
- **ErrorWidget** - Error display with retry action

### **Navigation Widgets**
- **CustomAppBar** - Styled app bar with actions
- **CustomBottomNav** - Bottom navigation bar
- **CustomDrawer** - Side navigation drawer

### **Analytics Widgets**
- **StatCard** - Display statistics
- **ChartCard** - Wrapper for charts
- **TrendIndicator** - Up/down trend display

---

## 🏗️ Implementation Approach

### **Architecture Pattern**
```
Presentation Layer (UI + BLoC)
        ↓
Repository Layer (Data abstraction)
        ↓
Data Sources (Hive, Dio)
```

### **No Use Cases Approach**
- Direct repository calls from BLoC
- Business logic handled in repositories
- Keeps architecture simple and maintainable

### **Lazy Loading**
- Screens are loaded only when navigated
- Images and heavy widgets lazy loaded
- Pagination for large lists

### **Error Handling Flow**
```
Data Layer → Repository → BLoC → UI
    ↓            ↓         ↓      ↓
  Either      Either    State  Snackbar
 (Success)  (Success)  (Loaded) (Message)
 (Failure)  (Failure)  (Error)  (Friendly)
```

### **API Request Handling**
- Centralized `ApiClient` class in `core/network/`
- Automatic error parsing and mapping
- Request/response interceptors for logging
- Network connectivity checks
- Retry mechanism for failed requests

### **Logging Strategy**
```dart
✅ API Requests: [REQUEST] method + endpoint
✅ API Responses: [RESPONSE] status + data
✅ Operations: [OPERATION] feature + action
✅ Errors: [ERROR] type + message + stack trace
```

### **Dependency Injection Setup**
```dart
// Auto-generated with injectable
@InjectableInit()
void configureDependencies() => getIt.init();

// Register singletons, lazy singletons, and factories
@singleton, @lazySingleton, @injectable
```

### **Routing Strategy**
- Declarative routes with go_router
- Type-safe navigation
- Deep linking support
- Nested navigation for tabs
- Route guards for protected screens

---

## 📱 Screen Implementation

### **Lazy Loading Pattern**
```dart
// Lazy load heavy widgets
late final Widget _heavyWidget;

@override
void initState() {
  super.initState();
  _heavyWidget = HeavyWidget(); // Load when needed
}
```

### **Pagination Pattern**
```dart
// Infinite scroll with pagination
ScrollController _scrollController;
void _onScroll() {
  if (_scrollController.position.pixels == 
      _scrollController.position.maxScrollExtent) {
    context.read<Bloc>().add(LoadMoreEvent());
  }
}
```

---

## 🔐 Data Models

### **Hive Type IDs**
- Subscription: 0
- PaymentMethod: 1
- Settings: 2
- CurrencyRates: 3

### **Model Structure**
```dart
@HiveType(typeId: 0)
class SubscriptionModel extends HiveObject {
  @HiveField(0)
  final String id;
  // ... fields
}
```

---

## 🌍 Currency System

### **Source**
- GitHub JSON API (fawazahmed0/currency-api)
- CDN: `https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/{currency}.json`

### **Supported Currencies**
- USD (United States Dollar)
- INR (Indian Rupee)
- EUR (Euro)

### **Conversion Logic**
```dart
// Convert via USD as base
double amountInUSD = amount / rates[fromCurrency]!;
double convertedAmount = amountInUSD * rates[toCurrency]!;
```

---

## 📋 Best Practices

### **Code Quality**
- ✅ Follow Flutter/Dart style guide
- ✅ Use const constructors wherever possible
- ✅ Immutable models and states
- ✅ Null safety enabled
- ✅ Proper error handling at every layer
- ✅ Comprehensive logging

### **Performance**
- ✅ Lazy loading for screens
- ✅ Pagination for lists
- ✅ Image caching
- ✅ Debouncing for search
- ✅ Efficient BLoC state updates

### **Testing**
- ✅ Unit tests for repositories
- ✅ Widget tests for UI components
- ✅ BLoC tests for state management
- ✅ Integration tests for critical flows

---

## 📝 Documentation Guidelines

**DO NOT create documentation for every small implementation.**

### **Maintain Only 3 Core Documents:**
1. **README.md** - Project overview and setup instructions
2. **TECH_STACK.md** - This file (tech stack, UI patterns, implementation notes)
3. **PROJECT_PROGRESS.md** - Feature tracking, bugs, and progress

### **Keep Documentation:**
- ✅ Simple and scannable
- ✅ Updated with major changes only
- ✅ Focused on "what" and "why", not "how"
- ❌ Don't document obvious code
- ❌ Don't duplicate code comments
- ❌ Don't create separate docs for each feature

---

## 🔧 Environment Setup

### **Requirements**
- Flutter SDK: ^3.9.0
- Dart SDK: ^3.9.0
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### **Build Commands**
```bash
# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build APK
flutter build apk --release

# Build Web
flutter build web --release
```

---

**Last Updated:** 5 October 2025
