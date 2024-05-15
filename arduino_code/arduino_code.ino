#include <ArduinoJson.h>
#include <ArduinoJson.hpp>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <Wire.h>
#include <BH1750.h>
#include "DHT.h"

/********************    DEFINE VARS    ********************/
const char* ssid = "Khongten";
const char* password = "14753690";

//Your Domain name with URL path or IP address with path
const char* postDataRequest = "http://192.168.1.145:6868/api/add_boards";
const char* getLightOnRequest = "http://192.168.1.145:6868/api/get_lighton";

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastTime = 0;
// Set timer to 5 seconds (5000)
unsigned long timerDelay = 15000;

// Json doc
DynamicJsonDocument sendDoc(1024);
DynamicJsonDocument resDoc(1024);

// Define vars of BF1750 (Light sensor)
bool BH1750Check = false;
BH1750 lightMeter;
float lux;

// Define vars of DHT22 sensor
#define DHTPIN 2 //D4
#define DHTTYPE DHT22 
DHT dht(DHTPIN, DHTTYPE);
float temp = 0;
float hum = 0;

// Define var of LEDS
const int LED1 = D5;
const int LED2 = D6;
bool light1_on = false;
bool light2_on = false;

//Local IP
String ip;


/********************    Functions    ********************/

//Connect to wifi
void ConnectWifi() {
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  ip = IpAddress2String(WiFi.localIP());
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());

  Serial.println("Timer set to 5 seconds (timerDelay variable), it will take 5 seconds before publishing the first reading.");
}

//Create Json send data
String JsonData() {
  // doc["sensor"] = "gps";
  // doc["time"]   = 1351824120;
  // doc["data"][0] = 48.756080;
  // doc["data"][1] = 2.302038;
  LightSenData();
  DHTSenData();
  sendDoc["name"] = "Wemos D1";
  sendDoc["ip"] = ip;
  sendDoc["id"] = 23001;
  sendDoc["data"]["temperature"] = (int)temp;
  sendDoc["data"]["humidity"] = (int)hum;
  sendDoc["data"]["light"] = (int)lux;

  // Serialize JSON document
  String json;
  serializeJson(sendDoc, json);

  return json;
}

//Send data using HTTP POST method
void SendData(String json) {

  //Check WiFi connection status
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, postDataRequest);

    // Send an HTTP request with a form type in payload
    // Specify content-type header
    // http.addHeader("Content-Type", "application/x-www-form-urlencoded");
    // String httpRequestData = "chuoiinput=nguyen&others=huunguyen";
    // Send HTTP POST request
    // int httpResponseCode = http.POST(httpRequestData);
    // Get Response from server
    // String httpResponse = http.getString();


    // Send an HTTP request with a json type in payload
    // Specify content-type header
    http.addHeader("Content-Type", "application/json");
    // Send HTTP POST request
    int httpResponseCode = http.POST(json);

    // Get Response from server
    String httpResponse = http.getString();

    Serial.println("HTTP Send data: ");
    // Show send data
    serializeJsonPretty(sendDoc, Serial);
    Serial.println();
    Serial.print("HTTP Response code: ");
    // Show response code
    Serial.println(httpResponseCode);

    http.end();

    getHttpRes(httpResponse);

  } else {
    Serial.println("WiFi Disconnected");
  }
}

// Get light on inform from app
void getLightOn() {
  //Check WiFi connection status
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;
    HTTPClient http;
    http.begin(client, getLightOnRequest);
    http.addHeader("Content-Type", "application/json");
    int httpCode = http.GET();
    Serial.println(httpCode);
    if(httpCode == HTTP_CODE_OK) {
      Serial.print("HTTP response code ");
      Serial.println(httpCode);
      String response = http.getString();
      Serial.println(response);
      getHttpRes(response);
    }
  http.end();
  }
}

// Get and deserialize data response from server ang get number of LEDs
void getHttpRes(String resData) {

  // Convert response data to Json object
  deserializeJson(resDoc, resData);

  // Get num of LEDS response from server
  light1_on = resDoc["light1_on"];
  light2_on = resDoc["light2_on"];

  // Show response data from server
  Serial.print("HTTP Response: ");
  serializeJsonPretty(resDoc, Serial);
  Serial.println();
}

// Get data form BH1750 sensor
void LightSenData() {
  BH1750Check = lightMeter.begin();
  if (BH1750Check) {
    lux = lightMeter.readLightLevel();
  } else {
    Serial.println(F("BH1750 Initialization FAILED"));
  }
}

// Get data form DHT22 sensor
void DHTSenData() {

  if (isnan(dht.readHumidity()) || isnan(dht.readTemperature())) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  else
  {
    hum = dht.readHumidity();
    temp = dht.readTemperature();
  }
}

// Convert IP address to String
String IpAddress2String(const IPAddress& ipAddress)
{
    return String(ipAddress[0]) + String(".") +
           String(ipAddress[1]) + String(".") +
           String(ipAddress[2]) + String(".") +
           String(ipAddress[3]);
}

// Handle LEDS
void handleLEDs() {
  if (light1_on == true) 
    digitalWrite(LED1, HIGH);
  else 
    digitalWrite(LED1, LOW);

  if (light2_on == true) 
    digitalWrite(LED2, HIGH);
  else 
    digitalWrite(LED2, LOW);

}

/********************     Main    ********************/

void setup() {
  Serial.begin(9600);
  ConnectWifi();
  lastTime = millis();

  // Initialize the I2C bus (BH1750 library doesn't do this automatically)
  Wire.begin(D2, D1);

  // Start DHT22 sensor 
  dht.begin();

  // Set output pin for LEDs
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
}

void loop() {
  //Send an HTTP POST request every 5 seconds
  if (((unsigned long)millis() - lastTime) > timerDelay) {

    // Get value from DHT22 and BH1750 sensor
    DHTSenData();
    LightSenData();

    // Send JSON data to API
    SendData(JsonData());


    // Test DHT22 and BH1750 sensor
    // Serial.print("Temperature: ");
    // Serial.println(temp);
    // Serial.print("Humidity: ");
    // Serial.println(hum);
    // Serial.print("Light: ");
    // Serial.println(lux);



    lastTime = millis();
    
  }
    getLightOn();
    handleLEDs();
    
}