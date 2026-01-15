# Smart Bidonville

Application mobile Flutter pour Android et iOS, connectée à un ESP32 TTGO T-Display. Le système simule une ventilation intelligente, affichage de la température, contrôle automatique ou manuel, et communication REST sécurisée via un token transmis par QR code.

## Ce que fait l’app

- Connexion utilisateur via Firebase Authentication : email, mot de passe, Google
- Appairage de l’ESP32 via QR code : IP, token
- Mode automatique avec seuils configurables et mode manuel : Slow, Medium, Fast
- Affichage de la température et de l’état du système

## Prérequis

- Flutter, Dart ^3.10
- Android Studio pour Android
- Xcode et CocoaPods pour iOS
- Configuration Firebase :
   - Android : `android/app/google-services.json`
   - iOS : `ios/GoogleService-Info.plist`

## Installation

```bash
flutter pub get
```

## Lancer l’app

### Android

Ouvrir le projet dans Android Studio, choisir un appareil, puis lancer.

Sinon :

```bash
flutter run
```

### iOS sur macOS

1) Ouvrir `ios/Runner.xcworkspace` dans Xcode.

2) Si le build iOS échoue à cause de CocoaPods ou du cache Xcode, aller dans `ios/` et exécuter exactement :

```bash
rm -rf Pods Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData
pod deintegrate
pod cache clean --all
pod repo update
pod install --repo-update
```

3) Build/Run depuis Xcode sur iPhone.

Sur iPhone physique, il faut activer le mode développeur et faire confiance au développeur dans les réglages iOS.

## Appairage ESP32

Le QR code contient :

```json
{
   "ip": "192.168.1.100",
   "token": "SmartHomeProject2024SecureToken",
   "name": "ESP32 Smart Fan"
}
```

Le token est ensuite envoyé sur l’API via : `Authorization: Bearer <token>`.
