# CLAUDE.md

## Projet : Frontend Flutter – SmartHome TTGO T‑Display

### 1. Objectif du document
Ce document décrit **pas à pas** la conception et l’implémentation du **frontend Flutter** permettant de piloter un microcontrôleur **TTGO T‑Display (ESP32)** via une **API RESTful**.

Il sert de guide de référence pour :
- l’architecture de l’application
- les fonctionnalités attendues
- le design UI/UX
- la communication réseau
- la gestion des erreurs
- les bonnes pratiques de développement

---

## 2. Rappel du backend existant (contrat API)

### 2.1 Endpoints disponibles

| Fonction | Méthode | Endpoint | Corps | Réponse |
|--------|--------|---------|------|--------|
| Lire le mode | GET | `/mode` | — | `{ mode }` |
| Changer le mode | PUT | `/mode` | `{ mode: auto|manual }` | `{ mode }` |
| État ventilateur | GET | `/fan/status` | — | `{ mode, speed, color, temperature }` |
| Contrôle manuel | PUT | `/fan/manual` | `{ speed, color }` | `{ speed, color }` |
| Seuil auto | PUT | `/fan/threshold` | `{ threshold }` | `{ threshold }` |
| Température | GET | `/temperature` | — | `{ temperature }` |

### 2.2 Authentification des requêtes

Toutes les requêtes API nécessitent un **jeton d'authentification** (auth token) envoyé via le header HTTP :

```
Authorization: Bearer <token>
```

- Si le token est absent ou invalide → réponse **401 Unauthorized**
- Le token est scanné via **QR code** lors du premier appairage
- Format QR code : `{"ip":"172.20.10.2","token":"xxx","name":"Device"}`

### 2.3 Contraintes importantes
- **Mode auto** : contrôle interdit du ventilateur
- **Couleur RGB** : format `"R,G,B"`
- **ESP32 local** : IP fixe ou saisie manuelle
- **Sécurité** : authentification par token obligatoire

---

## 3. Architecture Flutter recommandée

### 3.1 Pattern architectural

**MVVM simplifié (Clean Flutter)**

```
lib/
├── core/
│   ├── api/            # Client HTTP
│   ├── models/         # DTO / modèles
│   └── config/         # IP, constantes
├── features/
│   ├── dashboard/
│   │   ├── view/
│   │   ├── viewmodel/
│   │   └── widgets/
├── shared/
│   ├── widgets/
│   └── theme/
└── main.dart
```

### 3.2 State management

➡️ **Provider** ou **Riverpod** (au choix)

Responsabilités :
- état global du système
- synchronisation avec l’API
- gestion des erreurs réseau

---

## 4. Fonctionnalités de l’application

### 4.1 Modes de fonctionnement

Le système fonctionne selon **deux modes exclusifs** :

- **Mode manuel** : l’utilisateur choisit directement la vitesse du ventilateur.
- **Mode automatique** : la vitesse est déterminée automatiquement selon des **seuils de température**.

---

### 4.2 Mode manuel

#### Fonctionnement
- La vitesse du ventilateur n’est **plus exprimée en pourcentage**.
- L’utilisateur sélectionne une **vitesse discrète** parmi :
  - **Slow**
  - **Medium**
  - **Fast**

- Chaque vitesse correspond à une configuration interne fixe (PWM côté ESP32).

#### Correspondance vitesse / couleur RGB (automatique)

> Les couleurs **ne sont plus configurables par l’utilisateur**.
> Elles sont **déduites automatiquement de la vitesse**, aussi bien en mode manuel qu’en mode automatique.

| Vitesse | Couleur RGB | Signification |
|------|------|------|
| Slow | Rouge (255,0,0) | Faible activité |
| Medium | Bleu (0,0,255) | Activité modérée |
| Fast | Vert (0,255,0) | Activité élevée |

#### Comportement UI
- Sélecteur à choix exclusif (radio buttons ou segmented control)
- Feedback visuel immédiat via la couleur associée
- Contrôles désactivés si le mode automatique est actif

------|------|------|
| Slow | Rouge (255,0,0) | Faible activité |
| Medium | Bleu (0,0,255) | Activité modérée |
| Fast | Vert (0,255,0) | Activité élevée |

#### Comportement UI
- Boutons radio ou segmented control
- Indicateur couleur visible (icône / bande)
- Désactivé si le mode auto est actif

---

### 4.3 Mode automatique

#### Principe

En mode automatique, la vitesse du ventilateur est déterminée **exclusivement** par la température mesurée et par **trois seuils configurables**.

Aucune configuration manuelle de la vitesse ou des couleurs n’est possible dans ce mode.

#### Seuils de température

- **Seuil Slow**
- **Seuil Medium**
- **Seuil Fast**

Ces seuils définissent des **paliers de vitesse discrets**.

#### Logique de décision

| Température | Vitesse appliquée | Couleur affichée |
|-----------|------------------|------------------|
| T < seuil_slow | Ventilateur arrêté | — |
| seuil_slow ≤ T < seuil_medium | Slow | Rouge |
| seuil_medium ≤ T < seuil_fast | Medium | Bleu |
| T ≥ seuil_fast | Fast | Vert |

#### Configuration des seuils (Frontend)

- Trois sliders numériques (°C)
- Contraintes UI strictes :
  - `seuil_slow < seuil_medium < seuil_fast`
  - Plage autorisée : 0–50°C

#### Appels API

- `PUT /fan/thresholds`
```json
{
  "slow": 22,
  "medium": 26,
  "fast": 30
}
```

> ⚠️ Endpoint à adapter côté backend si nécessaire.

-----------|--------|--------|
| T < seuil_slow | Ventilateur arrêté | — |
| seuil_slow ≤ T < seuil_medium | Slow | Rouge |
| seuil_medium ≤ T < seuil_fast | Medium | Bleu |
| T ≥ seuil_fast | Fast | Vert |

#### Configuration des seuils

- Trois sliders numériques (°C)
- Contraintes :
  - `seuil_slow < seuil_medium < seuil_fast`
  - Plage recommandée : 0–50°C

#### Appels API

- `PUT /fan/thresholds`
```json
{
  "slow": 22,
  "medium": 26,
  "fast": 30
}
```

*(À adapter côté backend si nécessaire)*

---

### 4.2 Dashboard principal

#### Données affichées
- 🌡 Température actuelle
- ⚙️ Mode actuel (AUTO / MANUAL)
- 🌀 Vitesse ventilateur
- 🎨 Couleur RGB

---

### 4.3 Gestion du mode

- Switch AUTO / MANUAL
- Appel `PUT /mode`
- En AUTO :
  - désactivation des sliders
  - affichage du seuil

---

### 4.4 Mode automatique

- Slider seuil température (0–50°C)
- Appel `PUT /fan/threshold`
- Affichage logique embarquée :
  - vert → OK
  - jaune/orange → attention
  - rouge → critique

---

### 4.5 Mode manuel

- Choisir vitesse (slow/medium/fast)
- Bouton « Appliquer »
- Appel `PUT /fan/manual`

---

## 5. Appairage sécurisé et QR Code

### 5.1 Principe

L'application utilise un système d'**appairage par QR code** pour sécuriser la connexion à l'ESP32.

### 5.2 Méthodes de connexion

#### **Méthode 1 : QR Code (Recommandée)**

1. L'ESP32 génère un **token unique** au démarrage
2. Le token est imprimé sur le Serial Monitor au format JSON
3. L'utilisateur génère un **QR code** à partir du JSON (via https://www.qr-code-generator.com/)
4. Le QR code est **imprimé** et attaché au dispositif
5. L'utilisateur scanne le QR code avec l'application Flutter
6. L'app stocke les identifiants (IP + token) de manière sécurisée

**Avantages :**
- ✅ Authentification forte
- ✅ Pas de saisie manuelle d'IP
- ✅ Token stocké en local (SharedPreferences)
- ✅ Prévient l'accès non autorisé

#### **Méthode 2 : Saisie manuelle (Fallback)**

1. L'utilisateur entre manuellement l'adresse IP
2. Connexion sans token (moins sécurisée)
3. L'ESP32 peut refuser si AUTH_ENABLED = true

### 5.3 Format du QR Code

```json
{
  "ip": "172.20.10.2",
  "token": "SmartHomeProject2024SecureToken",
  "name": "ESP32 Smart Fan"
}
```

### 5.4 Stockage sécurisé

- **DeviceCredentials** : modèle contenant IP + token
- **Esp32Config** : singleton gérant le stockage persistant
- **SharedPreferences** : stockage local chiffré sur le téléphone

### 5.5 Transmission du token

Toutes les requêtes HTTP incluent automatiquement le header :

```
Authorization: Bearer SmartHomeProject2024SecureToken
```

---

## 6. Design UI / UX

### 6.1 Principes

- Minimaliste
- Lecture rapide
- Inspiré IoT / industriel

### 6.2 Couleurs

| État | Couleur |
|----|----|
| Normal | Vert |
| Attention | Jaune |
| Élevé | Orange |
| Critique | Rouge |

### 6.3 Widgets clés

- `Slider`
- `Switch`
- `Card`
- `CircularProgressIndicator`
- `SnackBar`
- `QrScannerScreen` (scan QR code)
- `IpConfigDialog` (saisie IP ou scan)

---

## 7. Communication réseau

### 7.1 Client HTTP

- package `http`
- timeout 3s
- JSON decoding sécurisé
- **Authentification automatique** via header `Authorization: Bearer <token>`

### 7.2 Exemple de service

- `FanApiService`
  - Méthode `_buildHeaders()` : ajoute automatiquement le token
  - `getStatus()` : récupère l'état du ventilateur
  - `setMode()` : change le mode auto/manual
  - `setManualFan()` : contrôle manuel de la vitesse
  - `setThresholds()` : configure les seuils de température

### 7.3 Dépendances

- `http: ^1.2.0` : requêtes HTTP
- `provider: ^6.1.1` : state management
- `shared_preferences: ^2.2.2` : stockage local
- `mobile_scanner: ^5.2.3` : scanner QR code

---

## 8. Gestion des erreurs

### 8.1 Cas traités
- ESP32 hors ligne
- Mauvaise IP
- JSON invalide
- Timeout
- **Token invalide (401 Unauthorized)**
- **QR code invalide/corrompu**

### 8.2 UX
- SnackBar rouge avec message d'erreur
- État désactivé pendant les erreurs
- Retry manuel via bouton
- Option de reconfiguration IP/token

---

## 9. Sécurité et bonnes pratiques

### 9.1 Sécurité implémentée

- ✅ **Authentification par token** : toutes les requêtes nécessitent un token valide
- ✅ **QR code** : provisionning sécurisé sans saisie manuelle
- ✅ **Stockage local chiffré** : SharedPreferences pour token et IP
- ✅ **HTTPS local** : network security config autorise HTTP uniquement pour IP locales
- ✅ **Validation côté ESP32** : vérification du token à chaque requête

### 9.2 Bonnes pratiques

- IP configurable et modifiable
- Pas de credentials hardcodés
- Validation UI stricte (seuils, format IP)
- Logs désactivables en production
- Mode test sans authentification (ESP32: `AUTH_ENABLED = false`)

### 9.3 Permissions Android/iOS

**Android** (`AndroidManifest.xml`) :
- `INTERNET` : communication réseau
- `ACCESS_NETWORK_STATE` : vérifier connectivité
- `CAMERA` : scanner QR code

**iOS** (`Info.plist`) :
- `NSCameraUsageDescription` : permission caméra pour QR scan

---

## 10. Tests

### 10.1 Tests unitaires

- Parsing JSON (DeviceCredentials, FanStatus)
- Validation des seuils de température
- Validation format QR code
- Stockage/récupération des credentials

### 10.2 Tests manuels

- Changement de mode (auto ↔ manual)
- Perte WiFi / reconnexion
- Reboot ESP32
- **Scan QR code** (valide / invalide / corrompu)
- **Authentification** (avec/sans token)
- Saisie manuelle d'IP

---

## 11. Livrables attendus

- Code Flutter documenté avec architecture clean
- Code ESP32 avec authentification
- `CLAUDE.md` (ce document)
- **QR code imprimé** pour démonstration
- Rapport LaTeX PDF
- AUTHORS

---

## 12. Extensions possibles (bonus)

- Historique température (graphique)
- Dark mode
- Scan réseau ESP32 automatique (mDNS)
- Notifications push pour seuil critique
- **Génération de token dynamique** côté ESP32 (avec EEPROM)
- **Multiple devices** : gestion de plusieurs ESP32

---

## 13. Conclusion

Cette application Flutter agit comme **interface de supervision IoT** claire, robuste et modulaire, respectant les attentes académiques et industrielles.

**Points forts de l'implémentation :**
- 🔒 Sécurité renforcée via authentification par token
- 📱 UX moderne avec scan QR code
- 🏗️ Architecture clean et maintenable
- 🌐 Communication réseau fiable avec gestion d'erreurs
- 📊 Contrôle complet du système de ventilation

L'ajout du système d'**appairage par QR code** démontre une compréhension des standards IoT modernes et des enjeux de sécurité dans les objets connectés.

