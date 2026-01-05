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

### 2.2 Contraintes importantes
- **Mode auto** : contrôle interdit du ventilateur
- **Couleur RGB** : format `"R,G,B"`
- **ESP32 local** : IP fixe ou saisie manuelle

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

## 5. Design UI / UX

### 5.1 Principes

- Minimaliste
- Lecture rapide
- Inspiré IoT / industriel

### 5.2 Couleurs

| État | Couleur |
|----|----|
| Normal | Vert |
| Attention | Jaune |
| Élevé | Orange |
| Critique | Rouge |

### 5.3 Widgets clés

- `Slider`
- `Switch`
- `Card`
- `CircularProgressIndicator`
- `SnackBar`

---

## 6. Communication réseau

### 6.1 Client HTTP

- package `http`
- timeout 3s
- JSON decoding sécurisé

### 6.2 Exemple de service

- `FanApiService`
- `getStatus()`
- `setMode()`
- `setManualFan()`

---

## 7. Gestion des erreurs

### Cas traités
- ESP32 hors ligne
- Mauvaise IP
- JSON invalide
- Timeout

### UX
- SnackBar rouge
- État désactivé
- Retry manuel

---

## 8. Sécurité et bonnes pratiques

- IP configurable
- Pas de credentials hardcodés
- Validation UI stricte
- Logs désactivables

---

## 9. Tests

### 9.1 Tests unitaires

- parsing JSON
- validation des seuils

### 9.2 Tests manuels

- changement mode
- perte WiFi
- reboot ESP32

---

## 10. Livrables attendus

- Code Flutter documenté
- `CLAUDE.md`
- Rapport LaTeX PDF
- AUTHORS

---

## 11. Extensions possibles (bonus)

- Historique température
- Dark mode
- Scan réseau ESP32
- Notifications seuil critique

---

## 12. Conclusion

Cette application Flutter agit comme **interface de supervision IoT** claire, robuste et modulaire, respectant les attentes académiques et industrielles.

