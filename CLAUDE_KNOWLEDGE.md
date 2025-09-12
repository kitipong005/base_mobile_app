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

## Notes for Future Claude Sessions
- This project has been cleaned up and stabilized
- Employee module was problematic and completely removed
- Focus on timesheet functionality if user wants features
- Always use established patterns (BLoC, Repository, BaseResponse)
- Run code generation after model changes
- Check `injection.dart` when adding new repositories/blocs