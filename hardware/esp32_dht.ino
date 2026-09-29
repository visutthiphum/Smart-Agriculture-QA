#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "DHT.h"

#define DHTPIN 4
#define DHTTYPE DHT11

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
const char* serverUrl =
    "http://<SERVER_IP>/smart_farm/api/store_telemetry.php";

DHT dht(DHTPIN, DHTTYPE);

void setup() {
    Serial.begin(115200);

    dht.begin();

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
}

void loop() {
    if (WiFi.status() == WL_CONNECTED) {

        float h = dht.readHumidity();
        float t = dht.readTemperature();

        if (!isnan(h) && !isnan(t)) {

            HTTPClient http;

            http.begin(serverUrl);
            http.addHeader("Content-Type", "application/json");

            JsonDocument doc;

            doc["temperature"] = t;
            doc["humidity"] = h;

            String jsonPayload;
            serializeJson(doc, jsonPayload);

            int httpResponseCode = http.POST(jsonPayload);

            http.end();
        }
    }

    delay(10000);
}
