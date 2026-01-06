# Smart Bidonville - Clean Architecture

## Project Structure

```
lib/
├── core/                           # Core business logic (domain layer)
│   ├── api/                       # API clients & networking
│   │   ├── api_exception.dart    # Typed exceptions for API errors
│   │   └── fan_api_service.dart  # REST client for ESP32
│   ├── config/                    # Configuration management
│   │   └── esp32_config.dart     # IP address storage & management
│   ├── models/                    # Domain models & DTOs
│   │   ├── fan_mode.dart         # Enum: Auto/Manual
│   │   ├── fan_speed.dart        # Enum: Slow/Medium/Fast
│   │   ├── fan_status.dart       # Complete system state DTO
│   │   ├── rgb_color.dart        # RGB color model
│   │   └── temperature_thresholds.dart  # Auto mode thresholds
│   └── services/                  # Core business services
│       └── auth_service.dart     # Firebase authentication service
│
├── features/                       # Feature modules (presentation layer)
│   ├── auth/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── login_screen.dart   # Firebase email/password login
│   │           └── signup_screen.dart  # User registration
│   └── dashboard/
│       ├── view/
│       │   └── dashboard_screen.dart      # Main dashboard screen
│       ├── viewmodel/
│       │   ├── dashboard_provider.dart    # State management (Provider)
│       │   └── dashboard_state.dart       # Immutable state model
│       └── widgets/
│           ├── auto_threshold_card.dart   # Auto mode threshold config
│           ├── fan_status_indicator.dart  # Fan state display
│           ├── manual_control_card.dart   # Manual speed control
│           ├── mode_switch_card.dart      # Auto/Manual toggle
│           └── temperature_card.dart      # Temperature display
│
├── shared/                         # Shared/common components
│   └── widgets/
│       └── ip_config_dialog.dart  # ESP32 IP configuration dialog
│
├── l10n/                          # Localization
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_fr.dart
│
├── firebase_options.dart          # Firebase configuration
└── main.dart                      # Application entry point
```

## Architecture Layers

### 1. **Core Layer** (Domain)
Pure business logic with no Flutter dependencies.

- **Models**: Immutable data classes representing domain entities
- **API**: Network communication abstraction
- **Config**: Application configuration management

### 2. **Features Layer** (Presentation)
MVVM pattern for UI logic.

- **View**: Flutter widgets (screens)
- **ViewModel**: State management with Provider
- **Widgets**: Reusable UI components

### 3. **Core Services Layer**
Business services in the core layer that can be shared across features.

- **AuthService**: Firebase authentication wrapper (email/password + Google Sign-In)

### 4. **Shared Layer**
Reusable components across the entire app.

- **Widgets**: Common UI components

## State Management

**Provider Pattern** (ChangeNotifier)

```
DashboardProvider (ChangeNotifier)
    ↓ (notifyListeners)
Consumer<DashboardProvider> widgets
    ↓ (rebuild)
UI updates automatically
```

### Key Features:
- Auto-polling every 4 seconds
- Immutable state with copyWith pattern
- Separation of concerns (State vs Provider)

## Data Flow

```
User Action
    ↓
Widget (View)
    ↓
Provider (ViewModel)
    ↓
API Service (Core)
    ↓
ESP32 Device
    ↓
Response → Provider → State Update → UI Rebuild
```

## API Integration

### ESP32 Endpoints
- `GET /mode` - Get current mode
- `PUT /mode` - Set mode (auto/manual)
- `GET /fan/status` - Get complete status
- `PUT /fan/manual` - Set manual speed
- `PUT /fan/threshold` - Configure auto thresholds
- `GET /temperature` - Get temperature reading

### Error Handling
Typed exceptions with user-friendly messages:
- `ApiExceptionType.timeout` - Connection timeout
- `ApiExceptionType.networkError` - Network unreachable
- `ApiExceptionType.invalidResponse` - JSON parse error
- `ApiExceptionType.notFound` - 404 errors
- `ApiExceptionType.serverError` - 5xx errors

## Dependencies

### Core
- `http: ^1.2.0` - REST API client
- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Persistent storage

### Authentication
- `firebase_core: ^3.8.1` - Firebase SDK
- `firebase_auth: ^5.3.4` - Firebase Auth
- `google_sign_in: ^6.2.1` - Google Sign-In

### Localization
- `intl: ^0.20.2` - Internationalization
- `flutter_localizations` - Flutter i18n

## Navigation Flow

```
App Start
    ↓
Firebase Init
    ↓
Auth Check
    ├─ Not Authenticated → LoginScreen
    │                          ↓
    │                      (after login)
    │                          ↓
    └─ Authenticated ────→ DashboardScreen
                              ↓
                         ESP32 IP Config (first time)
                              ↓
                         Dashboard UI (polling active)
```

## Clean Architecture Benefits

✅ **Separation of Concerns**: Each layer has a single responsibility
✅ **Testability**: Core logic is independent of Flutter
✅ **Maintainability**: Changes are isolated to specific layers
✅ **Scalability**: Easy to add new features following the same pattern
✅ **Reusability**: Models and services can be shared across features

## Code Quality

- **No compilation errors** ✅
- **42 info messages** (deprecation warnings, code style)
- **Static analysis passing** ✅
- **Clean git history** ✅

## Future Improvements

1. Add repository layer between ViewModel and API Service
2. Implement dependency injection (get_it)
3. Add unit tests for core models and API service
4. Add widget tests for dashboard components
5. Add integration tests for complete user flows
6. Implement dark mode toggle
7. Add temperature history graph
8. Add network scanning for ESP32 auto-discovery
