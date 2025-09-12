# Claude Knowledge Base - Base Mobile App Project

## Project Overview

This is a **Flutter mobile application** with the following architecture:
- **BLoC pattern** for state management
- **Repository pattern** for data access
- **Dependency Injection** using `get_it` and `injectable`
- **Hive** for local storage
- **Dio** for HTTP requests
- **Multi-environment support** (dev/staging/prod)

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart           # Environment-based configuration
│   │   └── hive_config.dart          # Hive database setup
│   ├── constants/
│   │   ├── api_endpoints.dart        # Centralized API endpoints
│   │   └── hive_boxes.dart          # Hive box constants
│   └── di/
│       ├── injection.dart           # Dependency injection setup
│       └── dio_module.dart          # Dio HTTP client configuration
├── data/
│   ├── models/
│   │   ├── base_response.dart       # Generic API response wrapper
│   │   ├── auth_models.dart         # Authentication models
│   │   ├── timesheet_models.dart    # Timesheet models
│   │   └── user_model.dart          # User models
│   └── repositories/
│       └── auth_repository.dart     # Authentication repository
├── features/
│   ├── auth/
│   │   └── bloc/                    # Authentication BLoC
│   └── example/
│       └── bloc/                    # Example BLoC
└── presentation/
    ├── pages/                       # UI pages
    ├── widgets/                     # Reusable widgets
    └── app.dart                     # Main app widget
```

## Key Learnings & Decisions

### 1. Employee Module Removal
**Context**: The project initially had an employee module that was causing errors.
**Action**: Completely removed the employee module including:
- `/lib/features/employee/` directory
- `employee_repository.dart`
- `employee_stats_models.dart`
- Updated all references in `dashboard_page.dart`, `profile_page.dart`, `app.dart`
- Regenerated dependency injection config

**Key Files Modified**:
- `dashboard_page.dart` - Simplified to basic dashboard
- `profile_page.dart` - Now uses AuthRepository directly for user data
- `app.dart` - Removed EmployeeBloc provider

### 2. Base Response Structure Implementation
**Problem**: API responses needed standardized handling.
**Solution**: Created `BaseResponseData<T>` class matching TypeScript interface:

```dart
class BaseResponseData<T> extends Equatable {
  final bool? success;
  final T? data;
  final String? message;
  final BasePagination? pagination;
  final bool? error;
  final int? statusCode;
  final String? statusMessage;
  final List<String>? stack;
  final MultiMessage? messages;
  final List<String>? details;
  
  // Helper methods
  bool get isSuccess => success == true && error != true;
  bool get hasError => error == true || success == false;
  String get errorMessage => message ?? statusMessage ?? 'Unknown error occurred';
}
```

**Usage Pattern**:
```dart
final baseResponse = BaseResponseData<YourModel>.fromJson(
  response.data,
  (data) => YourModel.fromJson(data),
);

if (baseResponse.hasError) {
  throw Exception(baseResponse.errorMessage);
}

return baseResponse.data!;
```

### 3. API Endpoints Centralization
**Problem**: Hardcoded API paths scattered throughout code.
**Solution**: Created `ApiEndpoints` class with constants and helper methods:

```dart
class ApiEndpoints {
  static const String baseUrl = '/api/v1';
  static const String auth = '$baseUrl/auth';
  static const String login = '$auth/login';
  
  // Helper methods for query parameters
  static String withPagination(String endpoint, {int? page, int? limit});
  static String withFilters(String endpoint, Map<String, dynamic> filters);
}
```

**Usage**:
```dart
final url = '${AppConfig.baseUrl}${ApiEndpoints.login}';
```

### 4. Authentication Flow
**Current Implementation**:
- `AuthBloc` manages authentication state
- `AuthRepository` handles API calls and local storage
- `LoginResponse` extends `BaseResponseData<LoginData>`
- Token stored in Hive with expiration
- User data cached separately

**Key Methods**:
- `login()` - Authenticate user
- `getSavedAuthToken()` - Get valid token
- `getSavedUserData()` - Get cached user info
- `logout()` - Clear all data

### 5. Model Structure Patterns
**Authentication Models**:
- `LoginRequest` - Login payload
- `LoginData` - Token + user data
- `LoginResponse` - Extends BaseResponseData<LoginData>
- `UserData` - User profile information
- `AuthToken` - Token with expiration (Hive stored)

**Timesheet Models** (available but not actively used):
- `Task`, `Timesheet`, `TimesheetSummary`
- `TimesheetStats`, `TimesheetBreakdowns`
- Support for categories, projects, approval workflow

## Flutter Version Compatibility

**Current Requirements (Updated):**
- Flutter: `>=3.35.0` (latest update)
- Dart SDK: `>=3.9.0 <4.0.0` (supports current 3.9.2)

**Installed Versions:**
- Flutter: 3.35.3 (stable channel)
- Dart: 3.9.2

**Recent Updates:**
- Updated from Flutter 3.10+ to 3.35+ for latest stability
- Used `fvm use stable` to manage Flutter versions
- Updated all dependencies to compatible versions:
  - flutter_bloc: ^9.1.1 (was ^8.1.3)  
  - bloc: ^9.0.0 (was ^8.1.2)
  - get_it: ^8.2.0 (was ^7.6.4)
  - dio: ^5.9.0 (was ^5.3.2)
  - flutter_lints: ^6.0.0 (was ^3.0.0)

**Important Notes:**
- All deprecated member warnings fixed (activeColor → activeThumbColor, RadioGroup implementation)
- Code generation regenerated after dependency updates
- Project fully compatible with Flutter 3.35.3 stable
- Always run `flutter pub outdated` before adding new dependencies

## Environment Configuration

**AppConfig.dart** pattern:
```dart
class AppConfig {
  static String get baseUrl {
    switch (flavor) {
      case 'dev': return 'https://dev-api.example.com/api';
      case 'staging': return 'https://staging-api.example.com/api';
      case 'prod': return 'https://api.example.com/api';
      default: return 'https://dev-api.example.com/api';
    }
  }
}
```

## Code Generation & Build

**Important Commands**:
```bash
# Regenerate code generation (models, DI)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Build for different flavors
flutter run --flavor dev
flutter run --flavor staging
flutter run --flavor prod
```

## Common Patterns

### 1. Repository Pattern
```dart
@singleton
class YourRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  Future<YourModel> getData() async {
    final authToken = _authRepository.getSavedAuthToken();
    if (authToken == null) {
      throw Exception('Authentication required');
    }

    final response = await _dio.get(
      '${AppConfig.baseUrl}${ApiEndpoints.yourEndpoint}',
      options: Options(headers: {
        'Authorization': 'Bearer ${authToken.token}',
        'Content-Type': 'application/json',
      }),
    );

    final baseResponse = BaseResponseData<Map<String, dynamic>>.fromJson(
      response.data,
      (data) => data as Map<String, dynamic>,
    );
    
    if (baseResponse.hasError) {
      throw Exception(baseResponse.errorMessage);
    }
    
    return YourModel.fromJson(baseResponse.data!);
  }
}
```

### 2. BLoC Pattern
```dart
@injectable
class YourBloc extends Bloc<YourEvent, YourState> {
  final YourRepository _repository;

  YourBloc(this._repository) : super(YourInitial()) {
    on<LoadData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadData event, Emitter<YourState> emit) async {
    try {
      emit(YourLoading());
      final data = await _repository.getData();
      emit(YourLoaded(data));
    } catch (e) {
      emit(YourError(e.toString()));
    }
  }
}
```

### 3. Page Structure
```dart
class YourPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Page')),
      body: BlocBuilder<YourBloc, YourState>(
        builder: (context, state) {
          if (state is YourLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is YourError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is YourLoaded) {
            return YourContent(data: state.data);
          }
          return Container();
        },
      ),
    );
  }
}
```

## Current State & Known Issues

### Working Features
- Authentication (login/logout)
- Multi-environment support
- Base response handling
- Local storage (Hive)
- Dependency injection
- Basic navigation

### Removed/Cleaned Up
- Employee module (completely removed due to errors)
- Unused API endpoints
- Example timesheet repository

### Potential Future Additions
- Timesheet management (models exist but no UI/logic)
- User profile editing
- Push notifications
- Offline support
- Error logging/analytics

## Development Guidelines

### When Adding New Features
1. **Create models** in `/data/models/` with `fromJson`/`toJson`
2. **Add API endpoints** to `ApiEndpoints` class
3. **Create repository** following the established pattern
4. **Create BLoC** for state management
5. **Add to dependency injection** in appropriate module
6. **Create UI pages/widgets** following BLoC pattern
7. **Run code generation** after model changes

### When Debugging
1. Check **dependency injection** setup in `injection.dart`
2. Verify **API endpoints** are correct in `ApiEndpoints`
3. Check **authentication token** validity
4. Use **BaseResponseData** error handling
5. Run `flutter analyze` for code issues
6. Regenerate code with build_runner if needed

### Code Standards
- Use **BLoC pattern** for state management
- **Repository pattern** for data access
- **BaseResponseData** for API responses
- **Centralized constants** for API endpoints
- **Proper error handling** with meaningful messages
- **Null safety** compliant code
- **Injectable** annotation for dependency injection

## Migration & Compatibility Issues

### Deprecated API Fixes Applied
1. **Switch Widget**: `activeColor` → `activeThumbColor`
2. **Radio Widget**: `RadioListTile` → `RadioGroup` wrapper pattern
3. **DropdownButtonFormField**: `value` → `initialValue`

### Breaking Changes Handled
- BLoC 8.x → 9.x: No breaking changes for basic usage
- get_it 7.x → 8.x: Compatible upgrade
- flutter_lints 3.x → 6.x: New lint rules (const constructor preferences)

### Flutter Version Upgrade Guide

**Step-by-step Upgrade Process:**
1. **Backup Current State**
   ```bash
   git add . && git commit -m "Pre-upgrade backup"
   ```

2. **Update Flutter Version**
   ```bash
   # Using FVM (recommended)
   fvm use stable
   fvm flutter --version
   
   # Or direct Flutter upgrade
   flutter upgrade
   flutter --version
   ```

3. **Update pubspec.yaml Requirements**
   ```yaml
   environment:
     sdk: '>=3.9.0 <4.0.0'  # Update to match new Dart version
     flutter: ">=3.35.0"     # Update to match new Flutter version
   ```

4. **Update Dependencies**
   ```bash
   # Check outdated packages
   flutter pub outdated
   
   # Update major versions (be careful!)
   flutter pub upgrade --major-versions
   
   # Or update specific packages
   flutter pub add flutter_bloc:^9.1.1 bloc:^9.0.0
   ```

5. **Regenerate Code**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

6. **Fix Deprecated APIs**
   ```bash
   flutter analyze
   # Fix any deprecated member warnings
   ```

7. **Test Everything**
   ```bash
   flutter test
   flutter run --debug
   ```

### Common Issues After Flutter Updates
- Always run code generation after dependency updates
- Check for deprecated widgets using `flutter analyze`
- Update import statements if package structure changes
- Verify device compatibility for new Flutter versions
- Fix breaking changes in major version updates (BLoC 8→9, etc.)

## Notes for Future Claude Sessions
- This project has been cleaned up and stabilized
- Employee module was problematic and completely removed
- Focus on timesheet functionality if user wants features
- Always use established patterns (BLoC, Repository, BaseResponse)
- Run code generation after model changes
- Check `injection.dart` when adding new repositories/blocs
- **Project is now Flutter 3.35.3 compatible with all deprecated warnings fixed**