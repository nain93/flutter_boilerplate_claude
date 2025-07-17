# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter boilerplate project implementing **Clean Architecture** with **BLoC pattern** for state management. The project features:
- **Clean Architecture**: Organized in Domain, Data, and Presentation layers
- **BLoC Pattern**: State management using flutter_bloc
- **Freezed**: Immutable data classes with union types for better type safety
- **Dependency Injection**: Using GetIt and Injectable for service location
- **API Integration**: Type-safe REST API client with Retrofit and Dio
- **Functional Programming**: Either types for error handling with Dartz

The project includes two example features:
- **Counter**: Local state management example
- **Users**: API integration example using JSONPlaceholder

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

### Code Generation
```bash
# Generate code for Freezed, Retrofit, JSON serialization, etc.
flutter packages pub run build_runner build

# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# Clean and regenerate all code
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── errors/            # Error handling (Freezed-based failures)
│   │   └── failures.dart
│   ├── usecases/          # Base UseCase classes
│   │   └── usecase.dart
│   ├── network/           # Network utilities & API service
│   │   ├── api_service.dart
│   │   └── network_info.dart
│   └── di/                # Dependency injection
│       └── injection_container.dart
└── features/
    ├── counter/           # Counter feature (local state example)
    │   ├── data/          # Data layer
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/        # Domain layer
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/  # Presentation layer
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    └── users/             # Users feature (API integration example)
        ├── data/          # Data layer
        │   ├── models/    # UserModel with JSON serialization
        │   └── repositories/
        ├── domain/        # Domain layer
        │   ├── entities/  # User entity (Freezed)
        │   ├── repositories/
        │   └── usecases/  # GetUsers, GetUserById
        └── presentation/  # Presentation layer
            ├── bloc/      # Freezed states/events
            ├── pages/
            └── widgets/
```

## Architecture

This project implements **Clean Architecture** with the following layers:

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Application-specific business rules

### 2. Data Layer (Data Access)
- **Models**: Data representation with JSON serialization
- **Data Sources**: Remote/Local data access (API, Database, Cache)
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer (UI)
- **BLoC**: Business Logic Components for state management
- **Pages**: Screen-level widgets
- **Widgets**: Reusable UI components

## State Management

- **BLoC Pattern**: Using flutter_bloc for predictable state management
- **Events**: User actions and system events
- **States**: UI state representations
- **Separation of Concerns**: Business logic separated from UI

## Dependencies

### Core
- **flutter**: Core Flutter SDK
- **cupertino_icons**: iOS-style icons

### State Management
- **flutter_bloc**: BLoC pattern implementation
- **bloc**: Core BLoC library

### Dependency Injection
- **get_it**: Service locator for dependency injection
- **injectable**: Code generation for dependency injection

### Network
- **dio**: HTTP client for API calls
- **retrofit**: Type-safe HTTP client generator

### Code Generation & Data Classes
- **freezed_annotation**: Immutable data classes with union types
- **json_annotation**: JSON serialization

### Utilities
- **dartz**: Functional programming (Either type for error handling)

### Dev Dependencies
- **build_runner**: Code generation runner
- **freezed**: Code generator for data classes
- **json_serializable**: JSON serialization generator
- **retrofit_generator**: API client generator
- **injectable_generator**: Dependency injection generator
- **flutter_lints**: Linting rules for code quality

## Key Files

### Core Architecture
- `lib/main.dart:5` - App entry point with dependency initialization
- `lib/core/di/manual_injection.dart` - Dependency injection setup
- `lib/core/errors/failures.dart` - Error handling with failure types
- `lib/core/usecases/usecase.dart` - Base UseCase interfaces

### Counter Feature (Local State Example)
- `lib/features/counter/domain/entities/counter.dart` - Counter entity (Freezed)
- `lib/features/counter/domain/repositories/counter_repository.dart` - Repository interface
- `lib/features/counter/domain/usecases/` - Business logic use cases
- `lib/features/counter/data/repositories/counter_repository_impl.dart` - Repository implementation
- `lib/features/counter/presentation/bloc/counter_bloc.dart` - State management
- `lib/features/counter/presentation/pages/counter_page.dart` - UI implementation

### Users Feature (API Integration Example)
- `lib/features/users/domain/entities/user.dart` - User entity (Freezed)
- `lib/features/users/data/models/user_model.dart` - User model with JSON serialization
- `lib/features/users/domain/usecases/get_users.dart` - Get all users use case
- `lib/features/users/domain/usecases/get_user_by_id.dart` - Get user by ID use case
- `lib/features/users/presentation/bloc/users_bloc.dart` - State management with Freezed states/events
- `lib/features/users/presentation/pages/users_page.dart` - Users list UI
- `lib/core/network/api_service.dart` - Retrofit API service for JSONPlaceholder

## API Integration

The project includes a complete API integration example using:
- **JSONPlaceholder API**: https://jsonplaceholder.typicode.com
- **Retrofit**: Type-safe HTTP client with code generation
- **Dio**: HTTP client for network requests
- **Error Handling**: Functional error handling with Either types

### Example API Usage
```dart
// Get all users
final result = await getUsers();
result.fold(
  (failure) => handleError(failure),
  (users) => displayUsers(users),
);

// Get user by ID
final result = await getUserById(1);
result.fold(
  (failure) => handleError(failure),
  (user) => displayUser(user),
);
```

## Adding New Features

1. Create feature folder under `lib/features/`
2. Implement domain layer (entities with Freezed, repositories, use cases)
3. Implement data layer (models with JSON serialization, data sources, repository implementations)
4. Implement presentation layer (BLoC with Freezed states/events, pages, widgets)
5. Register dependencies in `lib/core/di/injection_container.dart`
6. Run code generation: `flutter packages pub run build_runner build`
7. Add navigation routes if needed

## Best Practices

- Follow Clean Architecture principles
- Keep business logic in the domain layer
- Use BLoC for state management with Freezed states/events
- Implement proper error handling with Either types and Freezed failures
- Use Freezed for all data classes to ensure immutability and type safety
- Write unit tests for use cases and BLoCs
- Use dependency injection for testability
- Run code generation after adding new models or API endpoints
- Follow Dart/Flutter naming conventions