# Developer Guide - Base Mobile App

## Getting Started

### Prerequisites
- Flutter SDK 3.35.0+ (latest stable version)
- Dart SDK 3.9.0+
- FVM (Flutter Version Management) - recommended
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS builds)

### Initial Setup
```bash
# Clone and setup
git clone <repository-url>
cd base_mobile_app

# Setup Flutter version (if using FVM)
fvm use 3.35.3
fvm flutter --version

# Install dependencies
flutter pub get

# Generate code (models, dependency injection)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -t lib/main_dev.dart
# or
flutter run --flavor dev
```

## Architecture Overview

This project follows **Clean Architecture** principles with:

### State Management: BLoC Pattern
```
UI <-> BLoC <-> Repository <-> Data Source (API/Local)
```

### Dependency Injection
Uses `get_it` + `injectable` for automatic dependency registration.

### Data Flow
1. **UI** triggers events to **BLoC**
2. **BLoC** calls **Repository** methods
3. **Repository** fetches data from **API** or **Local Storage**
4. **Repository** returns models to **BLoC**
5. **BLoC** emits new state to **UI**

## Project Structure Explained

```
configs/
├── firebase/                # FileBase    
│   └── prod/                # the folders are separated by name for flavor               
├── launcher_icons/          # Images for setting launcher in 'flutter_launcher_icons-*.yaml'              
│    └── prod/               # the folders are separated by name for flavor     
├── splash_screen/           # Images for splash screen in 'flutter_native_splash-*.yaml'     
│   └── prod/                # the folders are separated by name for flavor     
lib/
├── core/                    # Core functionality
│   ├── config/              # App configuration
│   ├── constants/           # Constants (API endpoints, Hive boxes)
│   └── di/                  # Dependency injection setup
├── data/                    # Data layer
│   ├── models/              # Data models
│   └── repositories/        # Data repositories
├── features/                # Feature modules (BLoC, events, states)
│   ├── auth/
│   └── example/
└── presentation/            # UI layer
    ├── pages/               # App screens
    ├── widgets/             # Reusable UI components
    └── app.dart            # Main app widget
```

## Development Workflow

### 1. Adding New Features

**Step-by-step process:**

1. **Create Models** (if needed)
```dart
// lib/data/models/your_model.dart
class YourModel extends Equatable {
  final String id;
  final String name;

  const YourModel({required this.id, required this.name});

  factory YourModel.fromJson(Map<String, dynamic> json) => YourModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  @override
  List<Object> get props => [id, name];
}
```
**OR Create Models (With json_serializable and freezed)** (if needed)
```dart
// lib/data/models/your_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';
@freezed
class YourModel with _$YourModel {
  const factory YourModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at') DateTime? createdAt, //-- remote created_at convert to formJon is createAt
  }) = _YourModel;

  factory YourModel.fromJson(Map<String, dynamic> json) => _$YourModelFromJson(json);
}
```

2. **Add API Endpoints**
```dart
// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String yourFeature = '$baseUrl/your-feature';
  static const String yourFeatureById = '$yourFeature/{id}';
  
  static String getYourFeatureById(String id) => 
    yourFeatureById.replaceAll('{id}', id);
}
```

3. **Create Repository**
```dart
// lib/data/repositories/your_repository.dart
@singleton
class YourRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  YourRepository(this._dio, this._authRepository);

  Future<List<YourModel>> getItems() async {
    final authToken = _authRepository.getSavedAuthToken();
    if (authToken == null) {
      throw Exception('Authentication required');
    }

    final response = await _dio.get(
      '${AppConfig.baseUrl}${ApiEndpoints.yourFeature}',
      options: Options(headers: {
        'Authorization': 'Bearer ${authToken.token}',
        'Content-Type': 'application/json',
      }),
    );

    final baseResponse = BaseListResponse<YourModel>.fromJson(
      response.data,
      (json) => YourModel.fromJson(json),
    );
    
    if (baseResponse.hasError) {
      throw Exception(baseResponse.errorMessage);
    }
    
    return baseResponse.data ?? [];
  }
}
```

4. **Create BLoC (Event, State, BLoC)**
```dart
// lib/features/your_feature/bloc/your_event.dart
abstract class YourEvent extends Equatable {
  const YourEvent();
  @override
  List<Object> get props => [];
}

class LoadYourData extends YourEvent {
  const LoadYourData();
}

// lib/features/your_feature/bloc/your_state.dart
abstract class YourState extends Equatable {
  const YourState();
  @override
  List<Object> get props => [];
}

class YourInitial extends YourState {}
class YourLoading extends YourState {}
class YourLoaded extends YourState {
  final List<YourModel> items;
  const YourLoaded(this.items);
  @override
  List<Object> get props => [items];
}
class YourError extends YourState {
  final String message;
  const YourError(this.message);
  @override
  List<Object> get props => [message];
}

// lib/features/your_feature/bloc/your_bloc.dart
@injectable
class YourBloc extends Bloc<YourEvent, YourState> {
  final YourRepository _repository;

  YourBloc(this._repository) : super(YourInitial()) {
    on<LoadYourData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadYourData event, Emitter<YourState> emit) async {
    try {
      emit(YourLoading());
      final items = await _repository.getItems();
      emit(YourLoaded(items));
    } catch (e) {
      emit(YourError(e.toString()));
    }
  }
}
```

5. **Create UI Page**
```dart
// lib/presentation/pages/your_page.dart
class YourPage extends StatefulWidget {
  const YourPage({super.key});

  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  @override
  void initState() {
    super.initState();
    context.read<YourBloc>().add(const LoadYourData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Feature')),
      body: BlocBuilder<YourBloc, YourState>(
        builder: (context, state) {
          if (state is YourLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YourError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<YourBloc>().add(const LoadYourData()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is YourLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.id),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

6. **Register in Dependency Injection**
```bash
# Auto-generated after running build_runner
flutter packages pub run build_runner build --delete-conflicting-outputs
```

7. **Add BLoC Provider to App**
```dart
// lib/presentation/app.dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => getIt<AuthBloc>()),
    BlocProvider(create: (context) => getIt<YourBloc>()),
  ],
  child: YourApp(),
)
```

### 2. Code Generation
**Always run after creating/modifying:**
- Models with `@HiveType`
- Classes with `@injectable`
- Any `part` files

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_bloc_test.dart

# Run with coverage
flutter test --coverage
```

## Common Patterns

### Error Handling
```dart
try {
  final result = await repository.getData();
  emit(DataLoaded(result));
} catch (e) {
  String errorMessage = 'Unknown error occurred';
  
  if (e.toString().contains('401')) {
    errorMessage = 'Please login again';
  } else if (e.toString().contains('Network')) {
    errorMessage = 'Please check your internet connection';
  } else {
    errorMessage = e.toString();
  }
  
  emit(DataError(errorMessage));
}
```

### Loading States
```dart
// Always show loading before async operations
emit(DataLoading());
final result = await repository.getData();
emit(DataLoaded(result));
```

### Authentication Check
```dart
// In every repository method that requires auth
final authToken = _authRepository.getSavedAuthToken();
if (authToken == null) {
  throw Exception('Authentication required: Please login again');
}
```

### Response Handling
```dart
// Always use BaseResponseData for API responses
final baseResponse = BaseResponseData<YourModel>.fromJson(
  response.data,
  (data) => YourModel.fromJson(data),
);

if (baseResponse.hasError) {
  throw Exception(baseResponse.errorMessage);
}

return baseResponse.data!;
```

## Debugging Guide

### Common Issues & Solutions

**1. Flutter Version Issues**
```
Error: The current Dart SDK version is X but this app requires Y
```
**Solution**: 
```bash
# Check versions
flutter --version
fvm flutter --version

# Update pubspec.yaml environment constraints
environment:
  sdk: '>=3.9.0 <4.0.0'
  flutter: ">=3.35.0"

# Use FVM for version consistency
fvm use stable
```

**2. Dependency Compatibility**
```
Error: version solving failed / incompatible dependencies
```
**Solution**:
```bash
# Check what's outdated
flutter pub outdated

# Update incrementally, not all at once
flutter pub upgrade flutter_bloc
flutter pub get

# For major version conflicts, update one by one
flutter pub add flutter_bloc:^9.1.1
```

**3. Deprecated API Warnings**
```
Warning: 'activeColor' is deprecated and shouldn't be used
```
**Solution**: Follow migration guides:
- Switch: `activeColor` → `activeThumbColor`
- Radio: Use `RadioGroup` wrapper
- DropdownFormField: `value` → `initialValue`

**4. Code Generation Errors**
```
Error: build_runner build failed
```
**Solution**:
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**5. Dependency Injection Errors**
```
Error: GetIt: Object/factory with type X is not registered
```
**Solution**: Run code generation after adding new `@injectable` classes

**6. Model Parsing Errors**
```
Error: type 'Null' is not a subtype of type 'String'
```
**Solution**: Check your `fromJson` methods for null safety:
```dart
// Bad
name: json['name'],

// Good
name: json['name'] as String? ?? '',
```

**7. BLoC Not Emitting States**
```dart
// Bad - missing await
repository.getData();
emit(DataLoaded(data));

// Good
final data = await repository.getData();
emit(DataLoaded(data));
```

**8. Flavor/Environment Issues**
- Check `AppConfig.flavor` is set correctly in main_*.dart files
- Verify `AppConfig.baseUrl` returns correct URL for environment
- Use `flutter run -t lib/main_dev.dart` instead of `--flavor`

### Debug Tools
```dart
// Add logging in BLoCs
@override
void onChange(Change<YourState> change) {
  super.onChange(change);
  print('${change.currentState.runtimeType} -> ${change.nextState.runtimeType}');
}

// Add logging in repositories
print('API Request: ${AppConfig.baseUrl}${ApiEndpoints.yourEndpoint}');
print('Response: ${response.data}');
```

## Flutter Version Management

### Using FVM (Recommended)
```bash
# Install FVM
dart pub global activate fvm

# Use specific Flutter version for this project
fvm use 3.35.3

# Check current version
fvm flutter --version

# List available versions
fvm releases

# Use stable channel
fvm use stable
```

### Direct Flutter Commands
```bash
# Check current version
flutter --version

# Upgrade to latest stable
flutter upgrade

# Switch channel
flutter channel stable
flutter upgrade
```

### Version Consistency in Team
Create `.fvm/fvm_config.json` (already included):
```json
{
  "flutterSdkVersion": "3.35.3"
}
```

## Environment Management

### Flavors (Manual Setup)
```bash
# Development
flutter run -t lib/main_dev.dart

# Staging  
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart
```

**Note**: This project uses manual flavor setup, not flutter_flavorizr

### Configuration
Environment-specific settings in `app_config.dart`:
```dart
static String get baseUrl {
  switch (flavor) {
    case 'dev': return 'https://dev-api.example.com/api';
    case 'staging': return 'https://staging-api.example.com/api';
    case 'prod': return 'https://api.example.com/api';
    default: return 'https://dev-api.example.com/api';
  }
}
```

### Flavors (Using flutter_flavorizr)
```bash
# run flavor
flutter pub run flutter_flavorizr
```
flavor settings in `pubspec.yaml`:
**Read Setting**: [text](https://pub.dev/packages/flutter_flavorizr)

### flutter_native_splash (Using flutter_flavorizr)
Create `flutter_native_splash-*.yaml` Given `*` flavor name
Ex. `flutter_native_splash-prod.yaml` for `--flavors prod`
**Setup file**: [text](https://pub.dev/packages/flutter_native_splash)
Run
```bash 
  flutter pub run flutter_native_splash:create --flavors prod
```
```
project_name/
├── android/                 
│   └── app/
│       └── src/
│           └── prod/        # generate forder name follow flavor name and file native splash auto 
└── ios/                    
    └── Runner/              
        └── Base.lproj/      # generate LaunchScreen follow flavor name 'LaunchScreenProd.storyboard'  
```
**Note**: This package will generate a native splash file based on the flavor name.

### flutter_launcher_icons (Using flutter_flavorizr)
Create `flutter_launcher_icons-*.yaml` Given `*` flavor name
Ex. `flutter_launcher_icons-prod.yaml` for `--flavors prod`
**Setup file**: [text](https://github.com/fluttercommunity/flutter_launcher_icons/tree/master/example/flavors)
Run
```bash 
  flutter pub run --flavors prod
```
**Note**: This package don't `pub run` but run when user run or build project with flavors.

### Envlopment (Env Setup)
Create `.env` (root project)
```env
API_KEY = 'https://api.example.com/api'
```
Env settings in `pubspec.yaml`
```yaml
assets:
    - .env
```
 
### Configuration
```dart
  Future<EnvConfig> provideEnv() async {
    await dotenv.load(fileName: ".env");
    final env = EnvConfig();
    env.setup(dotenv);
    return env;
  }
```
Run 
```bash 
  flutter packages pub run build_runner build --delete-conflicting-outputs
```
**Note**: This `EnvConfig` using injection.

## Code Standards

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

### Widget Guidelines
```dart
// Always use const constructors when possible
const Text('Hello World'),

// Prefer named constructors
const SizedBox.shrink(),

// Extract complex widgets to separate methods or classes
Widget _buildComplexSection() {
  return Column(/* ... */);
}
```

### State Management Rules
- One BLoC per feature
- Keep BLoCs simple and focused
- Always handle loading/error states
- Use Equatable for events and states

## Security Best Practices

### Authentication
- Tokens stored securely in Hive
- Auto-logout on token expiration
- API calls include proper headers

### Data Validation
```dart
// Always validate data from APIs
factory YourModel.fromJson(Map<String, dynamic> json) {
  try {
    return YourModel(
      id: json['id']?.toString() ?? 'unknown',
      name: json['name']?.toString() ?? '',
    );
  } catch (e) {
    // Log error and return default
    print('Error parsing YourModel: $e');
    return YourModel(id: 'error', name: 'Unknown');
  }
}
```

## Deployment

### Pre-deployment Checklist
- [ ] Flutter version consistent: `fvm flutter --version`
- [ ] Dependencies up to date: `flutter pub outdated`
- [ ] No deprecated warnings: `flutter analyze`
- [ ] All tests pass: `flutter test`
- [ ] Code generation up to date: `flutter packages pub run build_runner build`
- [ ] Proper environment configuration
- [ ] Version number updated in `pubspec.yaml`
- [ ] Test on different devices/OS versions

### Build Commands
```bash
# Android
flutter build apk --flavor prod
flutter build appbundle --flavor prod

# iOS  
flutter build ios --flavor prod
```

## Additional Resources

### Key Dependencies
- **flutter_bloc**: State management
- **get_it + injectable**: Dependency injection
- **dio**: HTTP client
- **hive**: Local storage
- **equatable**: Value equality

### Useful Commands
```bash
# Clean build
flutter clean && flutter pub get

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated

# Generate app icons
flutter pub run flutter_launcher_icons:main
```

## Contributing

### Before Submitting PRs
1. Run `flutter analyze` (should have 0 issues)
2. Run `flutter test` (all tests should pass)
3. Follow established code patterns
4. Update documentation if needed
5. Test on both Android and iOS if possible

### Git Workflow
```bash
# Feature branch
git checkout -b feature/your-feature-name

# Regular commits
git add .
git commit -m "feat: add your feature description"

# Push and create PR
git push origin feature/your-feature-name
```

---

## Need Help?

1. Check `CLAUDE_KNOWLEDGE.md` for project context
2. Review existing code patterns in the project
3. Check Flutter documentation: https://flutter.dev/docs
4. BLoC documentation: https://bloclibrary.dev