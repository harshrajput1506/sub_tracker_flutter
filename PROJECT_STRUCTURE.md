# Project Structure Template

This document provides an overview of the project structure.

## Core Structure

```
lib/
├── main.dart                           # App entry point
├── core/                               # Core functionality
│   ├── constants/                      # App constants
│   │   ├── app_constants.dart         # Spacing, radius, elevation constants
│   │   └── constants.dart             # API, Hive, settings constants
│   ├── di/                            # Dependency injection
│   │   └── injection.dart             # DI setup with injectable
│   ├── error/                         # Error handling
│   │   ├── failures.dart              # Failure classes
│   │   └── exception_handler.dart     # Exception handling utility
│   ├── network/                       # Network layer
│   │   └── api_client.dart            # Dio API client with error handling
│   ├── router/                        # Navigation
│   │   └── app_router.dart            # GoRouter configuration
│   ├── theme/                         # App theming
│   │   ├── app_colors.dart            # Color palette
│   │   ├── app_text_styles.dart       # Typography
│   │   ├── theme.dart                 # Theme configuration
│   │   └── util.dart                  # Theme utilities
│   ├── utils/                         # Utilities
│   │   ├── formatters.dart            # Date & currency formatters
│   │   ├── logger.dart                # App logger
│   │   ├── snackbar_utils.dart        # Snackbar utilities
│   │   └── validators.dart            # Input validators
│   └── widgets/                       # Shared widgets
│       ├── custom_button.dart         # Button widget
│       ├── custom_card.dart           # Card widget
│       ├── custom_dropdown.dart       # Dropdown widget
│       ├── custom_text_field.dart     # Text field widget
│       ├── empty_state_widget.dart    # Empty state widget
│       ├── error_display_widget.dart  # Error display widget
│       └── loading_indicator.dart     # Loading indicator
│
├── data/                              # Data layer
│   ├── models/                        # Data models
│   │   ├── subscription_model.dart    # Subscription model
│   │   ├── payment_method_model.dart  # Payment method model
│   │   ├── currency_rates_model.dart  # Currency rates model
│   │   └── settings_model.dart        # Settings model
│   ├── repositories/                  # Repositories
│   │   ├── subscription_repository.dart
│   │   ├── payment_repository.dart
│   │   ├── currency_repository.dart
│   │   └── settings_repository.dart
│   └── datasources/                   # Data sources
│       ├── local/                     # Local storage
│       │   ├── subscription_local_datasource.dart
│       │   ├── payment_local_datasource.dart
│       │   └── settings_local_datasource.dart
│       └── remote/                    # Remote API
│           └── currency_remote_datasource.dart
│
└── features/                          # Feature modules
    ├── subscriptions/                 # Subscriptions feature
    │   ├── bloc/                      # BLoC
    │   │   ├── subscription_bloc.dart
    │   │   ├── subscription_event.dart
    │   │   └── subscription_state.dart
    │   └── screens/                   # Screens
    │       ├── subscriptions_list_screen.dart
    │       ├── add_subscription_screen.dart
    │       ├── edit_subscription_screen.dart
    │       └── subscription_detail_screen.dart
    │
    ├── payments/                      # Payment methods feature
    │   ├── bloc/
    │   │   ├── payment_bloc.dart
    │   │   ├── payment_event.dart
    │   │   └── payment_state.dart
    │   └── screens/
    │       ├── payments_list_screen.dart
    │       └── add_payment_screen.dart
    │
    ├── analytics/                     # Analytics feature
    │   ├── bloc/
    │   │   ├── analytics_bloc.dart
    │   │   ├── analytics_event.dart
    │   │   └── analytics_state.dart
    │   ├── screens/
    │   │   └── analytics_screen.dart
    │   └── widgets/
    │       ├── spending_chart.dart
    │       ├── category_chart.dart
    │       └── stat_card.dart
    │
    ├── settings/                      # Settings feature
    │   ├── bloc/
    │   │   ├── settings_bloc.dart
    │   │   ├── settings_event.dart
    │   │   └── settings_state.dart
    │   └── screens/
    │       └── settings_screen.dart
    │
    └── notifications/                 # Notifications feature
        └── notification_service.dart
```

## Key Implementation Notes

### 1. **Lazy Loading**
- All screens are lazy loaded via GoRouter
- Heavy widgets loaded only when needed
- Pagination for large lists

### 2. **Error Handling**
- Every layer returns `Either<Failure, Success>`
- User-friendly error messages
- Comprehensive logging at all levels

### 3. **State Management**
- BLoC pattern with flutter_bloc
- Separate events, states, and BLoC files
- No use cases - direct repository calls

### 4. **Dependency Injection**
- Using get_it with injectable
- Code generation for DI setup
- Singleton and factory patterns

### 5. **Routing**
- GoRouter for declarative routing
- Type-safe navigation
- Nested navigation with bottom bar

### 6. **API Client**
- Centralized Dio client
- Request/response interceptors
- Automatic error handling
- Retry mechanism

### 7. **Logging**
- Logger for all operations
- API request/response logs
- Error and operation tracking
- Formatted console output

## Running Code Generation

```bash
# Generate code for injectable and hive
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Next Steps

1. Create data models with Hive adapters
2. Implement repositories with error handling
3. Create BLoC for each feature
4. Build UI screens with shared widgets
5. Implement currency API integration
6. Setup local notifications
7. Add analytics charts
