# 🚀 Quick Start Guide

Get started with the Subscription Manager app in 5 minutes!

---

## ⚡ Installation

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

That's it! The app should now be running.

---

## 📁 Project Overview

```
lib/
├── main.dart                    # App entry point
├── core/                        # Shared functionality
│   ├── widgets/                # Reusable UI components
│   ├── theme/                  # App styling
│   ├── router/                 # Navigation
│   ├── network/                # API client
│   └── utils/                  # Helpers
├── data/                        # Data layer
│   ├── models/                 # Data models
│   └── repositories/           # Data repositories
└── features/                    # App features
    ├── subscriptions/          # Subscription management
    ├── analytics/              # Analytics & reports
    ├── payments/               # Payment methods
    └── settings/               # App settings
```

---

## 🎨 Using Shared Widgets

All UI components are in `lib/core/widgets/`. Here's how to use them:

### Button
```dart
CustomButton(
  text: 'Save',
  onPressed: () => save(),
  icon: Icons.save,
)
```

### Text Field
```dart
CustomTextField(
  label: 'Name',
  controller: controller,
  validator: Validators.required,
)
```

### Card
```dart
CustomCard(
  child: Text('Content'),
  onTap: () => print('tapped'),
)
```

See [WIDGETS_REFERENCE.md](WIDGETS_REFERENCE.md) for all widgets.

---

## 🎯 Creating a New Feature

### 1. Create Feature Folder
```
lib/features/my_feature/
├── bloc/
│   ├── my_feature_bloc.dart
│   ├── my_feature_event.dart
│   └── my_feature_state.dart
└── screens/
    └── my_feature_screen.dart
```

### 2. Create BLoC

```dart
// my_feature_event.dart
abstract class MyFeatureEvent extends Equatable {
  const MyFeatureEvent();
}

class LoadData extends MyFeatureEvent {
  @override
  List<Object> get props => [];
}

// my_feature_state.dart
abstract class MyFeatureState extends Equatable {
  const MyFeatureState();
}

class MyFeatureInitial extends MyFeatureState {
  @override
  List<Object> get props => [];
}

class MyFeatureLoading extends MyFeatureState {
  @override
  List<Object> get props => [];
}

class MyFeatureLoaded extends MyFeatureState {
  final List<dynamic> data;
  
  const MyFeatureLoaded(this.data);
  
  @override
  List<Object> get props => [data];
}

class MyFeatureError extends MyFeatureState {
  final String message;
  
  const MyFeatureError(this.message);
  
  @override
  List<Object> get props => [message];
}

// my_feature_bloc.dart
class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> {
  final MyRepository repository;
  
  MyFeatureBloc(this.repository) : super(MyFeatureInitial()) {
    on<LoadData>(_onLoadData);
  }
  
  Future<void> _onLoadData(
    LoadData event,
    Emitter<MyFeatureState> emit,
  ) async {
    emit(MyFeatureLoading());
    
    final result = await repository.getData();
    
    result.fold(
      (failure) => emit(MyFeatureError(failure.getUserMessage())),
      (data) => emit(MyFeatureLoaded(data)),
    );
  }
}
```

### 3. Create Screen

```dart
class MyFeatureScreen extends StatelessWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyFeatureBloc(repository)..add(LoadData()),
      child: Scaffold(
        appBar: CustomAppBar(title: 'My Feature'),
        body: BlocBuilder<MyFeatureBloc, MyFeatureState>(
          builder: (context, state) {
            if (state is MyFeatureLoading) {
              return LoadingIndicator();
            }
            
            if (state is MyFeatureError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () => context.read<MyFeatureBloc>().add(LoadData()),
              );
            }
            
            if (state is MyFeatureLoaded) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    child: Text(state.data[index].toString()),
                  );
                },
              );
            }
            
            return EmptyStateWidget(
              icon: Icons.inbox,
              title: 'No data',
            );
          },
        ),
      ),
    );
  }
}
```

### 4. Add Route

In `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: '/my-feature',
  name: 'myFeature',
  builder: (context, state) =>
      _lazyLoadScreen(() => const MyFeatureScreen()),
),
```

### 5. Navigate

```dart
context.goNamed('myFeature');
```

---

## 🗄️ Creating a Repository

```dart
// lib/data/repositories/my_repository.dart
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:sub/core/error/failures.dart';

@lazySingleton
class MyRepository {
  final MyLocalDataSource localDataSource;
  
  MyRepository(this.localDataSource);
  
  Future<Either<Failure, List<MyModel>>> getData() async {
    try {
      final data = await localDataSource.getData();
      return Right(data);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get data', e, stackTrace);
      return Left(CacheFailure(message: 'Failed to load data'));
    }
  }
  
  Future<Either<Failure, void>> saveData(MyModel data) async {
    try {
      await localDataSource.saveData(data);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save data', e, stackTrace);
      return Left(CacheFailure(message: 'Failed to save data'));
    }
  }
}
```

---

## 📱 Common Patterns

### Show Snackbar
```dart
SnackBarUtils.showSuccess(context, 'Saved!');
SnackBarUtils.showError(context, 'Failed to save');
```

### Form Validation
```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: Column(
    children: [
      CustomTextField(
        validator: Validators.required,
      ),
      CustomButton(
        text: 'Submit',
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Process form
          }
        },
      ),
    ],
  ),
)
```

### Format Date
```dart
DateFormatter.format(DateTime.now());           // 05 Oct 2025
DateFormatter.formatRelative(DateTime.now());   // Just now
```

### Format Currency
```dart
CurrencyFormatter.format(125.50, 'USD');  // $125.50
```

### Logging
```dart
AppLogger.info('User action');
AppLogger.error('Something went wrong', error, stackTrace);
AppLogger.operation('Subscriptions', 'Add', data: subscription);
```

---

## 🔧 Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code (run after changing models)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (auto-generate)
flutter pub run build_runner watch --delete-conflicting-outputs

# Format code
flutter format lib/

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean
```

---

## 📖 Documentation

- **[README.md](README.md)** - Project overview
- **[TECH_STACK.md](TECH_STACK.md)** - Tech details
- **[WIDGETS_REFERENCE.md](WIDGETS_REFERENCE.md)** - Widget examples
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup
- **[PROJECT_PROGRESS.md](PROJECT_PROGRESS.md)** - Progress tracking

---

## 💡 Pro Tips

1. **Use shared widgets** - Don't create custom widgets when shared ones exist
2. **Follow the pattern** - Copy existing BLoC structure for new features
3. **Log everything** - Use AppLogger for debugging
4. **Handle errors** - Always return Either<Failure, T> from repositories
5. **Validate inputs** - Use Validators for all form fields
6. **Keep docs updated** - Update PROJECT_PROGRESS.md as you work
7. **Run code generation** - After changing models with @HiveType
8. **Use constants** - AppSpacing, AppRadius, etc. for consistency

---

## 🆘 Need Help?

1. Check [WIDGETS_REFERENCE.md](WIDGETS_REFERENCE.md) for widget usage
2. Look at existing code for patterns
3. Check [TECH_STACK.md](TECH_STACK.md) for architecture details
4. Review error messages in the console
5. Run `flutter doctor` to check setup

---

**Happy Coding! 🎉**

Start by implementing your first feature using the patterns above!
