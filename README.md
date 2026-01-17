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

#### Lancement via Xcode

1. Ouvrir le workspace Xcode :
```bash
cd ios
open Runner.xcworkspace
```

2. **IMPORTANT** : Toujours ouvrir `Runner.xcworkspace` et NON `Runner.xcodeproj`

3. Dans Xcode :
   - Sélectionner votre appareil (iPhone) ou simulateur
   - Product ---> Build (⌘B)
   - Product ---> Run (⌘R)

#### Configuration requise

##### Sur iPhone physique

- Activer le **mode développeur** : Réglages ---> Confidentialité et sécurité ---> Mode développeur
- Faire confiance au développeur : Réglages ---> Général ---> Gestion des appareils
- S'assurer que l'iPhone est déverrouillé pendant le déploiement

##### Signing & Capabilities

Si erreur "Development team not configured" :
1. Dans Xcode, sélectionner le projet Runner
2. Onglet Signing & Capabilities
3. Sélectionner votre Team ou cocher "Automatically manage signing"

#### En cas de problèmes

##### Erreur "No such module" ou erreurs de pods

Si vous rencontrez des erreurs de type "No such module 'AppAuth'",

**Essayez d'abord cette solution rapide ** :

```bash
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
```

Puis relancer depuis Xcode (Product ---> Build ---> Run)

**Si le problème persiste**, solution complète (peut prendre 15-30 minutes) :

```bash
cd ios
rm -rf Pods Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData
pod deintegrate
pod cache clean --all
pod repo update
pod install 
cd ..
flutter clean
flutter pub get
```

Puis relancer depuis Xcode (Product → Build → Run)

##### Erreur de build persistante

En cas d'erreurs persistantes liées au dossier build :

```bash
sudo rm -rf build
sudo xattr -cr .
flutter clean
flutter pub get
cd ios
open Runner.xcworkspace
```

Puis relancer depuis Xcode

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


## Documentation API

La documentation Swagger de l’API est disponible ici :

https://app.swaggerhub.com/apis/universityofmontpell/smart-home-api/1.0.0