#include <WiFi.h>
#include <WebServer.h>
#include <math.h>
#include <TFT_eSPI.h>
#include <ArduinoJson.h>

// ==================== SECURITY CONFIGURATION ====================
// ⚠️ IMPORTANT: Change this token to something unique for your device!
const char* AUTH_TOKEN = "SmartHomeProject2024SecureToken";
const char* DEVICE_NAME = "ESP32 Smart Bidonville";

// Set to false to disable authentication (for testing only!)
const bool AUTH_ENABLED = true;

// Configuration WiFi
const char* ssid = "Fadels phone";
const char* password = "fadel...";

// ==================== CONFIGURATION MATÉRIELLE ====================

// Pin de la thermistance (ADC)
const int thermistorPin = 36;

// Paramètres de la thermistance NTC
const float nominalResistance = 10000.0;
const float nominalTemp = 25.0;
const float beta = 3950.0;
const float seriesResistor = 10000.0;

// Pins pour le ventilateur et LED RGB
const int fanPWMPin = 25;
const int ledRedPin = 13;
const int ledGreenPin = 15;
const int ledBluePin = 2;

// PWM Configuration
const int pwmFreq = 5000;
const int pwmResolution = 8;

const bool DEBUG = true;

// Temp override (test)
bool tempOverrideEnabled = false;
float tempOverrideValue = 22.0;

// ==================== OBJETS GLOBAUX ====================

WebServer server(80);
TFT_eSPI tft = TFT_eSPI();

// ==================== ÉTAT DU SYSTÈME (MODEL) ====================

struct VentilatorState {
    String mode;              // "auto" or "manual"
    int fanSpeed;             // 0-100 (PWM duty cycle approx)
    int rgbRed;               // 0-255
    int rgbGreen;             // 0-255
    int rgbBlue;              // 0-255
    float temperature;        // Température actuelle

    // Les 3 seuils de température
    float thresholdSlow;      // Seuil activation SLOW
    float thresholdMedium;    // Seuil activation MEDIUM
    float thresholdFast;      // Seuil activation FAST
};

// Initialisation avec des valeurs par défaut cohérentes
VentilatorState state = {
        "auto",    // mode
        0,         // fanSpeed
        0, 0, 0,   // RGB (Off)
        22.0,      // temperature
        22.0,      // thresholdSlow (ex: >22°C = Slow)
        26.0,      // thresholdMedium (ex: >26°C = Medium)
        30.0       // thresholdFast (ex: >30°C = Fast)
};

// ==================== SECURITY FUNCTIONS ====================

/**
 * Validates the Authorization header
 * Expected format: "Bearer <token>"
 * Returns true if valid, false otherwise
 */
bool validateAuth() {
    if (!AUTH_ENABLED) {
        if (DEBUG) Serial.println("⚠️  AUTH DISABLED - Request allowed");
        return true; // Auth disabled for testing
    }

    // Check if Authorization header exists
    if (!server.hasHeader("Authorization")) {
        if (DEBUG) Serial.println("❌ AUTH FAILED: No Authorization header");
        server.send(401, "application/json", "{\"error\":\"Unauthorized\",\"message\":\"Missing Authorization header\"}");
        return false;
    }

    String authHeader = server.header("Authorization");

    // Check format: "Bearer <token>"
    String expectedAuth = "Bearer " + String(AUTH_TOKEN);

    if (authHeader != expectedAuth) {
        if (DEBUG) {
            Serial.println("❌ AUTH FAILED: Invalid token");
            Serial.println("   Expected: " + expectedAuth);
            Serial.println("   Received: " + authHeader);
        }
        server.send(401, "application/json", "{\"error\":\"Unauthorized\",\"message\":\"Invalid authentication token\"}");
        return false;
    }

    if (DEBUG) Serial.println("✅ AUTH SUCCESS");
    return true;
}

/**
 * Prints QR code data to Serial Monitor for printing
 * Call this once during setup
 */
void printQRCodeData() {
    String ipAddress = WiFi.localIP().toString();

    // JSON format expected by Flutter app
    String qrData = "{\"ip\":\"" + ipAddress +
                    "\",\"token\":\"" + String(AUTH_TOKEN) +
                    "\",\"name\":\"" + String(DEVICE_NAME) + "\"}";

    Serial.println("\n╔════════════════════════════════════════════════════════════╗");
    Serial.println("║           🔐 GENERATE YOUR SECURITY QR CODE 🔐            ║");
    Serial.println("╚════════════════════════════════════════════════════════════╝");
    Serial.println("\n📋 Copy the text below and paste it into a QR code generator:");
    Serial.println("   (https://www.qr-code-generator.com/ or similar)\n");
    Serial.println("─────────────────────────────────────────────────────────────");
    Serial.println(qrData);
    Serial.println("─────────────────────────────────────────────────────────────");
    Serial.println("\n📱 Steps to create your QR code:");
    Serial.println("   1. Go to: https://www.qr-code-generator.com/");
    Serial.println("   2. Select 'Text' or 'Free Text' option");
    Serial.println("   3. Paste the JSON above");
    Serial.println("   4. Download the QR code as PNG/PDF");
    Serial.println("   5. Print it (minimum 5cm x 5cm)");
    Serial.println("   6. Scan with your Flutter app to connect securely!\n");

    if (AUTH_ENABLED) {
        Serial.println("🔒 Authentication: ENABLED");
    } else {
        Serial.println("⚠️  Authentication: DISABLED (for testing only)");
    }
    Serial.println("═══════════════════════════════════════════════════════════\n");
}

// ==================== FONCTIONS UTILITAIRES ====================

float readTemperature() {
    int sum = 0;
    for (int i = 0; i < 5; i++) {
        sum += analogRead(thermistorPin);
        delay(2);
    }
    int analogValue = sum / 5;
    float voltage = analogValue * 3.3 / 4095.0;
    if (voltage == 0) return -273.15; // Éviter division par zéro

    float resistance = (3.3 - voltage) / voltage * seriesResistor;
    float temperatureK = 1.0 / (1.0 / (nominalTemp + 273.15) + (1.0 / beta) * log(resistance / nominalResistance));
    return temperatureK - 273.15;
}

/**
 * Applique les réglages hardware (PWM Fan + PWM RGB)
 * Règle globale: si fan OFF => LED OFF
 */
void applyFanSettings() {
    // Conversion vitesse 0-100 vers PWM 0-255
    int pwmValue = map(state.fanSpeed, 0, 100, 0, 255);
    ledcWrite(fanPWMPin, pwmValue);

    // RÈGLE GLOBALE : si ventilateur OFF → LED OFF
    if (state.fanSpeed == 0) {
        ledcWrite(ledRedPin, 0);
        ledcWrite(ledGreenPin, 0);
        ledcWrite(ledBluePin, 0);
        return;
    }

    // Sinon appliquer la couleur normale
    ledcWrite(ledRedPin, state.rgbRed);
    ledcWrite(ledGreenPin, state.rgbGreen);
    ledcWrite(ledBluePin, state.rgbBlue);
}

/**
 * Définit la couleur en fonction de la vitesse (Logique métier imposée)
 * Slow (30)   -> Rouge (255,0,0)
 * Medium (60) -> Bleu (0,0,255)
 * Fast (100)  -> Vert (0,255,0)
 */
void enforceColorLogic() {
    if (state.fanSpeed == 0) {
        state.rgbRed = 0; state.rgbGreen = 0; state.rgbBlue = 0; return;
    } else if (state.fanSpeed <= 30) {
        // SLOW -> ROUGE
        state.rgbRed = 255; state.rgbGreen = 0; state.rgbBlue = 0;
    } else if (state.fanSpeed <= 60) {
        // MEDIUM -> BLEU
        state.rgbRed = 0; state.rgbGreen = 0; state.rgbBlue = 255;
    } else {
        // FAST -> VERT
        state.rgbRed = 0; state.rgbGreen = 255; state.rgbBlue = 0;
    }
}

/**
 * Convert integer speed (0-100) to string format
 */
String speedToString(int speed) {
    if (speed == 0) return "";  // Fan off
    if (speed <= 30) return "slow";
    if (speed <= 60) return "medium";
    return "fast";
}

/**
 * Convert string speed to integer (0-100)
 */
int stringToSpeed(String speedStr) {
    speedStr.toLowerCase();
    if (speedStr == "slow") return 30;
    if (speedStr == "medium") return 60;
    if (speedStr == "fast") return 100;
    return 0;  // Default/off
}

/**
 * Logique du mode automatique (Mise à jour selon les 3 seuils)
 */
void updateAutoMode() {
    float t = state.temperature;

    if (t < state.thresholdSlow) {
        // < Seuil Slow : Arrêt
        state.fanSpeed = 0;
    } else if (t < state.thresholdMedium) {
        // [Slow, Medium[ : Vitesse Slow
        state.fanSpeed = 30;
    } else if (t < state.thresholdFast) {
        // [Medium, Fast[ : Vitesse Medium
        state.fanSpeed = 60;
    } else {
        // >= Fast : Vitesse Fast
        state.fanSpeed = 100;
    }

    // Appliquer la couleur correspondante et envoyer au hardware
    enforceColorLogic();
    applyFanSettings();
}

// Mise à jour de l'écran (Simplifiée pour la lisibilité)
void updateDisplay() {
    static int lastSpeed = -1;
    static String lastMode = "";
    static float lastTemp = -999;

    // Rafraîchissement complet si changement majeur
    bool forceRefresh = (state.mode != lastMode);

    if (forceRefresh) {
        tft.fillScreen(TFT_BLACK);
        tft.setTextSize(2);
        tft.setTextColor(TFT_CYAN, TFT_BLACK);
        tft.setCursor(20, 10);
        tft.println("SMART BIDONVILLE IoT");
        lastSpeed = -1; // Force redraw speed
    }

    // Affichage Température
    if (abs(state.temperature - lastTemp) > 0.1 || forceRefresh) {
        tft.fillRect(0, 40, tft.width(), 30, TFT_BLACK);
        tft.setTextSize(2);
        tft.setCursor(10, 45);
        tft.setTextColor(TFT_WHITE, TFT_BLACK);
        tft.print(state.temperature, 1);
        tft.print(" C");
        lastTemp = state.temperature;
    }

    // Affichage Mode
    if (state.mode != lastMode || forceRefresh) {
        tft.fillRect(120, 45, 100, 30, TFT_BLACK);
        tft.setTextSize(2);
        tft.setCursor(120, 45);
        if (state.mode == "auto") tft.setTextColor(TFT_GREEN, TFT_BLACK);
        else tft.setTextColor(TFT_MAGENTA, TFT_BLACK);
        tft.print(state.mode == "auto" ? "AUTO" : "MAN");
        lastMode = state.mode;
    }

    // Affichage Vitesse & Couleur
    if (state.fanSpeed != lastSpeed || forceRefresh) {
        tft.fillRect(0, 90, tft.width(), 40, TFT_BLACK);

        // Barre de progression
        int barWidth = map(state.fanSpeed, 0, 100, 0, tft.width() - 20);
        tft.drawRect(10, 90, tft.width() - 20, 20, TFT_WHITE);

        uint16_t color = tft.color565(state.rgbRed, state.rgbGreen, state.rgbBlue);
        if (barWidth > 0) {
            tft.fillRect(12, 92, barWidth - 4, 16, color);
        }

        // Texte vitesse
        tft.setTextSize(1);
        tft.setTextColor(TFT_WHITE, TFT_BLACK);
        tft.setCursor(10, 115);
        tft.print("Vitesse: ");
        if(state.fanSpeed == 0) tft.print("OFF");
        else if(state.fanSpeed <= 30) tft.print("SLOW");
        else if(state.fanSpeed <= 60) tft.print("MEDIUM");
        else tft.print("FAST");

        lastSpeed = state.fanSpeed;
    }
}

// ==================== HANDLERS API (WITH AUTHENTICATION) ====================

void handleGetMode() {
    if (!validateAuth()) return; // 🔒 Check authentication

    StaticJsonDocument<64> doc;
    doc["mode"] = state.mode;
    String res; serializeJson(doc, res);
    server.send(200, "application/json", res);
}

void handleSetMode() {
    if (!validateAuth()) return; // 🔒 Check authentication

    if (!server.hasArg("plain")) { server.send(400, "application/json", "{}"); return; }
    StaticJsonDocument<64> doc;
    deserializeJson(doc, server.arg("plain"));

    String newMode = doc["mode"].as<String>();
    if (newMode == "auto" || newMode == "manual") {
        state.mode = newMode;
        if (state.mode == "auto") updateAutoMode(); // Apply auto logic immediately

        String res;
        doc["mode"] = state.mode;
        serializeJson(doc, res);
        server.send(200, "application/json", res);
    } else {
        server.send(400, "application/json", "{\"error\":\"Invalid mode\"}");
    }
}

// Retourne l'état complet, y compris les seuils pour le Frontend
void handleGetFanStatus() {
    if (!validateAuth()) return; // 🔒 Check authentication

    StaticJsonDocument<512> doc;
    doc["mode"] = state.mode;
    doc["speed"] = speedToString(state.fanSpeed);  // STRING
    doc["color"] = String(state.rgbRed) + "," + String(state.rgbGreen) + "," + String(state.rgbBlue);
    doc["temperature"] = round(state.temperature * 10) / 10.0;

    // Ajout des seuils pour que le Frontend puisse initialiser ses sliders
    JsonObject thresholds = doc.createNestedObject("thresholds");
    thresholds["slow"] = state.thresholdSlow;
    thresholds["medium"] = state.thresholdMedium;
    thresholds["fast"] = state.thresholdFast;

    String res; serializeJson(doc, res);
    server.send(200, "application/json", res);
}

// Contrôle manuel : accepte speed en STRING ("slow/medium/fast") ou INT (0-100)
void handleSetManualFan() {
    if (!validateAuth()) return; // 🔒 Check authentication

    if (state.mode != "manual") {
        server.send(403, "application/json", "{\"error\":\"Switch to manual mode first\"}");
        return;
    }
    if (!server.hasArg("plain")) {
        server.send(400, "application/json", "{\"error\":\"Missing body\"}");
        return;
    }

    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, server.arg("plain"));
    if (error) {
        server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}");
        return;
    }

    if (!doc.containsKey("speed")) {
        server.send(400, "application/json", "{\"error\":\"Missing speed\"}");
        return;
    }

    // Accept BOTH string and integer for compatibility
    int speed = 0;

    if (doc["speed"].is<const char*>() || doc["speed"].is<String>()) {
        String speedStr = doc["speed"].as<String>(); // "slow", "medium", "fast"
        speed = stringToSpeed(speedStr);
    } else if (doc["speed"].is<int>()) {
        speed = doc["speed"].as<int>();
        if (speed < 0) speed = 0;
        if (speed > 100) speed = 100;
    } else {
        server.send(400, "application/json", "{\"error\":\"Invalid speed format\"}");
        return;
    }

    state.fanSpeed = speed;

    // Force la couleur selon la spécification
    enforceColorLogic();
    applyFanSettings();

    // Réponse avec speed au format STRING
    StaticJsonDocument<256> resDoc;
    resDoc["speed"] = speedToString(state.fanSpeed);  // STRING
    resDoc["color"] = String(state.rgbRed) + "," + String(state.rgbGreen) + "," + String(state.rgbBlue);

    String res; serializeJson(resDoc, res);
    server.send(200, "application/json", res);

    if (DEBUG) Serial.println("Manual Set: speed=" + String(state.fanSpeed) + " (" + speedToString(state.fanSpeed) + ")");
}

// Configuration des 3 seuils
void handleSetThresholds() {
    if (!validateAuth()) return; // 🔒 Check authentication

    if (!server.hasArg("plain")) { server.send(400, "application/json", "{\"error\":\"Missing body\"}"); return; }

    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, server.arg("plain"));
    if (error) { server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}"); return; }

    if (doc.containsKey("slow") && doc.containsKey("medium") && doc.containsKey("fast")) {
        float s = doc["slow"];
        float m = doc["medium"];
        float f = doc["fast"];

        // Validation logique : Slow < Medium < Fast
        if (s < m && m < f && s >= 0 && f <= 50) {
            state.thresholdSlow = s;
            state.thresholdMedium = m;
            state.thresholdFast = f;

            if (state.mode == "auto") updateAutoMode();

            // Réponse
            StaticJsonDocument<128> resDoc;
            resDoc["success"] = true;
            String res; serializeJson(resDoc, res);
            server.send(200, "application/json", res);

            if (DEBUG) Serial.printf("New Thresholds: %.1f / %.1f / %.1f\n", s, m, f);
        } else {
            server.send(400, "application/json", "{\"error\":\"Invalid thresholds (must be slow < medium < fast and 0-50)\"}");
        }
    } else {
        server.send(400, "application/json", "{\"error\":\"Missing slow/medium/fast keys\"}");
    }
}

void handleGetTemperature() {
    if (!validateAuth()) return; // 🔒 Check authentication

    StaticJsonDocument<64> doc;
    doc["temperature"] = round(state.temperature * 10) / 10.0;
    String res; serializeJson(doc, res);
    server.send(200, "application/json", res);
}

// Forcer la température pour test (override) + revenir au capteur
void handleSetTemperature() {
    if (!validateAuth()) return; // 🔒 Check authentication

    if (!server.hasArg("plain")) {
        server.send(400, "application/json", "{\"error\":\"Missing request body\"}");
        return;
    }

    StaticJsonDocument<128> doc;
    DeserializationError error = deserializeJson(doc, server.arg("plain"));
    if (error) {
        server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}");
        return;
    }

    // Revenir au mode normal (capteur)
    if (doc.containsKey("mode")) {
        String mode = doc["mode"].as<String>();
        mode.toLowerCase();

        if (mode == "sensor" || mode == "normal") {
            tempOverrideEnabled = false;

            StaticJsonDocument<128> res;
            res["override"] = false;
            res["mode"] = "sensor";
            String out; serializeJson(res, out);
            server.send(200, "application/json", out);

            if (DEBUG) Serial.println("PUT /temperature - Override disabled (sensor mode)");
            return;
        }

        server.send(400, "application/json", "{\"error\":\"Invalid mode. Use 'sensor'\"}");
        return;
    }

    // Forcer une température
    if (!doc.containsKey("value")) {
        server.send(400, "application/json", "{\"error\":\"Missing value\"}");
        return;
    }

    float value = doc["value"];
    if (value < -20 || value > 60) {
        server.send(400, "application/json", "{\"error\":\"Temperature must be between -20 and 60\"}");
        return;
    }

    tempOverrideEnabled = true;
    tempOverrideValue = value;

    // Appliquer immédiatement
    state.temperature = value;
    if (state.mode == "auto") updateAutoMode();

    StaticJsonDocument<128> res;
    res["override"] = true;
    res["temperature"] = value;
    String out; serializeJson(res, out);
    server.send(200, "application/json", out);

    if (DEBUG) Serial.println("PUT /temperature - Override enabled: " + String(value, 1) + "C");
}

void handleNotFound() {
    server.send(404, "application/json", "{\"error\":\"Not found\"}");
}

// ==================== SETUP ====================

void setup() {
    Serial.begin(115200);

    // Init TFT
    tft.init();
    tft.setRotation(1);
    tft.fillScreen(TFT_BLACK);
    tft.setTextSize(2);
    tft.setCursor(10, 10);
    tft.println("Booting...");

    // Init PWM
    ledcAttach(fanPWMPin, pwmFreq, pwmResolution);
    ledcAttach(ledRedPin, pwmFreq, pwmResolution);
    ledcAttach(ledGreenPin, pwmFreq, pwmResolution);
    ledcAttach(ledBluePin, pwmFreq, pwmResolution);

    applyFanSettings(); // Initialise à 0

    // WiFi
    Serial.print("Connecting to "); Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi Connected.");
    Serial.println(WiFi.localIP());

    tft.fillScreen(TFT_BLACK);
    tft.setCursor(10, 10);
    tft.setTextSize(1);
    tft.println("IP: " + WiFi.localIP().toString());

    // 🔐 Print QR Code data for printing
    printQRCodeData();

    // Routes API (ALL PROTECTED with authentication)
    server.on("/mode", HTTP_GET, handleGetMode);
    server.on("/mode", HTTP_PUT, handleSetMode);
    server.on("/fan/status", HTTP_GET, handleGetFanStatus);
    server.on("/fan/manual", HTTP_PUT, handleSetManualFan);
    server.on("/fan/threshold", HTTP_PUT, handleSetThresholds);
    server.on("/temperature", HTTP_GET, handleGetTemperature);
    server.on("/temperature", HTTP_PUT, handleSetTemperature);
    server.onNotFound(handleNotFound);

    server.begin();
    Serial.println("HTTP Server started");

    if (AUTH_ENABLED) {
        Serial.println("🔒 Security: ENABLED - All requests require authentication");
    } else {
        Serial.println("⚠️  Security: DISABLED - All requests are allowed (TESTING MODE)");
    }
}

// ==================== LOOP ====================

void loop() {
    server.handleClient();

    static unsigned long lastTempRead = 0;
    if (millis() - lastTempRead >= 1000) {
        lastTempRead = millis();

        // Lecture Température (capteur ou override)
        if (tempOverrideEnabled) {
            state.temperature = tempOverrideValue;
        } else {
            float rawTemp = readTemperature();
            // Filtre passe-bas simple pour éviter le bruit
            state.temperature = (state.temperature * 0.7) + (rawTemp * 0.3);
        }

        // Si Auto, mettre à jour la logique
        if (state.mode == "auto") {
            updateAutoMode();
        }

        updateDisplay();
    }
}
