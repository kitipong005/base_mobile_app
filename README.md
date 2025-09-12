# Flutter BLoC App

A Flutter project with BLoC pattern, Hive local storage, dependency injection, and flavors.

## Tech Stack

- **State Management**: BLoC (flutter_bloc)
- **Local Storage**: Hive
- **Dependency Injection**: get_it + injectable
- **Value Equality**: equatable
- **Widget Utilities**: GetX (for utilities like snackbars, navigation)
- **Flavors**: Development, Staging, Production

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart      # App configuration and flavors
│   │   └── hive_config.dart     # Hive initialization
│   ├── constants/
│   │   └── hive_boxes.dart      # Hive box names
│   ├── di/
│   │   └── injection.dart       # Dependency injection setup
│   └── utils/
│       └── equatable_utils.dart # Base classes for equatable
├── data/
│   ├── datasources/
│   │   └── local_datasource.dart # Local data operations
│   └── models/
│       └── user_model.dart       # Hive model example
├── features/
│   └── example/
│       └── bloc/                 # BLoC implementation
├── presentation/
│   └── pages/
│       └── home_page.dart        # Main page
├── main.dart                     # Default entry point (dev)
├── main_common.dart             # Common app setup
├── main_dev.dart               # Development flavor
├── main_staging.dart           # Staging flavor
└── main_prod.dart              # Production flavor
```

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code for Hive and Injectable:
```bash
flutter packages pub run build_runner build
```

3. Run the app:
```bash
# Development
flutter run -t lib/main_dev.dart

# Staging  
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart
```

## Features

- **BLoC Pattern**: Complete state management with events and states
- **Hive Storage**: Local database with type adapters
- **Dependency Injection**: Automatic dependency resolution
- **Flavors**: Multiple environment configurations
- **GetX Utilities**: Snackbars, dialogs, and navigation helpers
- **Equatable**: Value equality for models and states