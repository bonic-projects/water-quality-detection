//PH sensor
#define phPin 13
int phValue = 0;
float phReading = 0;

//Temperature sensor
#include <OneWire.h>
#include <DallasTemperature.h>
// // GPIO where the DS18B20 is connected to
const int oneWireBus = 32;          
// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(oneWireBus);
// Pass our oneWire reference to Dallas Temperature sensor
DallasTemperature tempSensor(&oneWire);
// // Temperature value
float temperature;

//EC sensor
// #include <Adafruit_ADS1015.h>
#include <DFRobot_ESP_EC.h>
//Pin
#define ecPin 14
DFRobot_ESP_EC ec;
// Adafruit_ADS1115 ads;
float ecVoltage, ecValue = 0;


//WiFi
#define wifiLedPin 5

//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyDJ0MOOuWDBwyKJdgEhBP52xYmTN9cL8QI"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://water-quality-detection-5ab50-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;

unsigned long printDataPrevMillis = 0;


void setup() {

  Serial.begin(115200);

  //Temperature
  tempSensor.begin();
 
  //EC
  ec.begin();
 
  //WIFI
  pinMode(wifiLedPin, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    digitalWrite(wifiLedPin, LOW);
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  digitalWrite(wifiLedPin, HIGH);
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";
}

void loop() {

    //PH sensor
    readPH();
  
    //Temperature
    readTemp();

    //EC
    readEC();

    printData();
  
    updateData();
}

void updateData(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 2000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("ph", phReading);
    json.set("temp", temperature);
    json.set("ec", ecValue);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
    Serial.println(""); 
  }
}

void printData(){
  if (millis() - printDataPrevMillis > 2000 || printDataPrevMillis == 0)
  {
    printDataPrevMillis = millis();
    //PH
    Serial.print("PH: ");
    Serial.print(phValue);
    Serial.print(" | ");
    Serial.println(phReading);
    //Temperature
    Serial.print("Temperature:");
    Serial.print(temperature, 2);
    Serial.println("ºC");
    //Print EC
    Serial.print("EC:");
    Serial.println(ecValue);
  }
}

void readPH(){
  phValue = analogRead(phPin);
  float voltage = phValue*(3.3/4095.0);
  phReading =((3.3*voltage)-1);
} 

void readTemp(){
  tempSensor.requestTemperatures();
  temperature = tempSensor.getTempCByIndex(0);  // read your temperature sensor to execute temperature compensation
}

void readEC(){
  ecVoltage = analogRead(ecPin);
  ecValue = ec.readEC(ecVoltage, temperature); // convert voltage to EC with temperature compensation
}