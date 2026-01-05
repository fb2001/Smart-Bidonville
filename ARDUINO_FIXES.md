# Arduino Code Fixes for Flutter Compatibility

## Issue 1: Change endpoint from `/fan/thresholds` to `/fan/threshold`

**Line ~331:** Change the route registration

```cpp
// OLD (WRONG):
server.on("/fan/thresholds", HTTP_PUT, handleSetThresholds);

// NEW (CORRECT):
server.on("/fan/threshold", HTTP_PUT, handleSetThresholds);
```

---

## Issue 2: Add speed conversion helper functions

**Add after line ~90 (after enforceColorLogic function):**

```cpp
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
```

---

## Issue 3: Update handleGetFanStatus to return string speed

**Replace lines ~218-226:**

```cpp
// OLD:
void handleGetFanStatus() {
    StaticJsonDocument<512> doc;
    doc["mode"] = state.mode;
    doc["speed"] = state.fanSpeed;  // ❌ INTEGER
    doc["color"] = String(state.rgbRed) + "," + String(state.rgbGreen) + "," + String(state.rgbBlue);
    doc["temperature"] = round(state.temperature * 10) / 10.0;

    // ... thresholds code ...
}

// NEW:
void handleGetFanStatus() {
    StaticJsonDocument<512> doc;
    doc["mode"] = state.mode;
    doc["speed"] = speedToString(state.fanSpeed);  // ✅ STRING
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
```

---

## Issue 4: Update handleSetManualFan to accept string speed

**Replace lines ~229-262:**

```cpp
// OLD:
void handleSetManualFan() {
    if (state.mode != "manual") {
        server.send(403, "application/json", "{\"error\":\"Switch to manual mode first\"}");
        return;
    }
    if (!server.hasArg("plain")) { server.send(400); return; }

    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, server.arg("plain"));
    if (error) { server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}"); return; }

    if (doc.containsKey("speed")) {
        int speed = doc["speed"];  // ❌ EXPECTS INTEGER
        // ... rest of code
    }
}

// NEW:
void handleSetManualFan() {
    if (state.mode != "manual") {
        server.send(403, "application/json", "{\"error\":\"Switch to manual mode first\"}");
        return;
    }
    if (!server.hasArg("plain")) { server.send(400); return; }

    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, server.arg("plain"));
    if (error) { server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}"); return; }

    if (doc.containsKey("speed")) {
        // Accept BOTH string and integer for compatibility
        int speed = 0;

        if (doc["speed"].is<String>()) {
            // Flutter sends string: "slow", "medium", "fast"
            String speedStr = doc["speed"].as<String>();
            speed = stringToSpeed(speedStr);
        } else if (doc["speed"].is<int>()) {
            // Fallback: accept integer 0-100
            speed = doc["speed"].as<int>();
            if(speed < 0) speed = 0;
            if(speed > 100) speed = 100;
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
        resDoc["speed"] = speedToString(state.fanSpeed);  // ✅ STRING
        resDoc["color"] = String(state.rgbRed) + "," + String(state.rgbGreen) + "," + String(state.rgbBlue);
        String res; serializeJson(resDoc, res);
        server.send(200, "application/json", res);
    } else {
        server.send(400, "application/json", "{\"error\":\"Missing speed\"}");
    }
}
```

---

## Issue 5: OPTIONAL - Remove thresholds from /fan/status response

The Flutter app doesn't use the thresholds from `/fan/status` (it manages them locally), so you can optionally remove that nested object to reduce payload size. But keeping it doesn't hurt.

---

## Summary of Changes

1. ✅ Change `/fan/thresholds` → `/fan/threshold` (line ~331)
2. ✅ Add `speedToString()` and `stringToSpeed()` helper functions
3. ✅ Update `handleGetFanStatus()` to return `speed` as STRING
4. ✅ Update `handleSetManualFan()` to accept `speed` as STRING (with integer fallback)

## Testing Checklist

After making these changes:

- [ ] Compile and upload to ESP32
- [ ] Test `GET /fan/status` - should return `speed: "slow"` (not `speed: 30`)
- [ ] Test `PUT /fan/manual` with `{"speed": "slow", "color": "255,0,0"}`
- [ ] Test `PUT /fan/threshold` with `{"slow": 22, "medium": 26, "fast": 30}`
- [ ] Verify Flutter app connects and controls the fan correctly

## Color Mapping Verification

Your color logic is already correct:
- Slow (≤30) → Red (255,0,0) ✅
- Medium (≤60) → Blue (0,0,255) ✅
- Fast (>60) → Green (0,255,0) ✅

This matches the Flutter implementation perfectly!
