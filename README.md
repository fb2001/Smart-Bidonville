# Smart Home - ESP32 Fan Controller

A Flutter application for controlling a TTGO T-Display ESP32 smart fan system via REST API. Features temperature monitoring, automatic/manual fan control, and secure QR code device pairing.

## Features

- **Temperature Monitoring**: Real-time temperature display in Celsius and Fahrenheit
- **Dual Control Modes**:
  - **Auto Mode**: Fan speed adjusts automatically based on temperature thresholds
  - **Manual Mode**: Direct control with Slow/Medium/Fast speed options
- **Secure Device Pairing**: QR code scanning for secure ESP32 connection with token authentication
- **Firebase Authentication**: Email/password and Google Sign-In support
- **Material 3 Design**: Modern UI with glassmorphism components and amber/gold theme

## Screenshots

The app design is based on Figma exports located in `/assets/`:
- `iPhone 13 Pro Max - 3.png` - Login screen
- `iPhone 13 Pro Max - 4.png` - Dashboard (Auto mode)
- `iPhone 13 Pro Max - 5.png` - Dashboard (Manual mode)

## Architecture

```
lib/
├── core/
│   ├── api/              # HTTP client, API service
│   ├── config/           # ESP32 configuration
│   ├── models/           # Data models (FanStatus, DeviceCredentials, etc.)
│   └── services/         # Auth service
├── features/
│   ├── auth/             # Login/Signup screens
│   ├── dashboard/        # Main dashboard, widgets, viewmodel
│   └── splash/           # Splash screen
├── shared/
│   ├── theme/            # Material 3 theme (app_theme.dart)
│   └── widgets/          # Reusable UI components
├── l10n/                 # Localization (EN/FR)
└── main.dart
```

## Design System

The app uses a custom Material 3 theme with:

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#D4A84B` | Amber/gold accent |
| Background | `#1A1A1A` | Dark background |
| Surface | `#2A2A2A` | Card backgrounds |
| Speed Slow | `#FF5252` | Red indicator |
| Speed Medium | `#448AFF` | Blue indicator |
| Speed Fast | `#4CAF50` | Green indicator |

### Components
- `GlassCard` / `SimpleGlassCard` - Glassmorphism containers
- `SegmentedToggle` - Auto/Manual mode selector
- `SpeedSelector` - Fan speed selection with icons
- `ThresholdInput` - Temperature threshold configuration
- `PrimaryButton` / `SecondaryButton` - Styled buttons
- `AppTextField` - Styled text inputs

## ESP32 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/mode` | Get current mode |
| PUT | `/mode` | Set mode (auto/manual) |
| GET | `/fan/status` | Get fan status |
| PUT | `/fan/manual` | Set manual speed |
| PUT | `/fan/threshold` | Set auto thresholds |
| GET | `/temperature` | Get temperature |

All requests require `Authorization: Bearer <token>` header.

## Setup

### Prerequisites
- Flutter SDK ^3.10.0
- Firebase project configured
- ESP32 with SmartHome firmware

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)
4. Run the app:
   ```bash
   flutter run
   ```

### ESP32 Pairing

1. Power on the ESP32 device
2. Generate a QR code from the device credentials JSON:
   ```json
   {
     "ip": "192.168.1.100",
     "token": "YourSecureToken",
     "name": "ESP32 Smart Fan"
   }
   ```
3. In the app, tap "Scan QR Code" to pair

## Dependencies

- `firebase_core` / `firebase_auth` - Authentication
- `google_sign_in` - Google authentication
- `provider` - State management
- `http` - REST API communication
- `shared_preferences` - Local storage
- `mobile_scanner` - QR code scanning

## License

This project is for educational purposes.
