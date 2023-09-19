
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ESP32Ping.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
BLECharacteristic *pCharacteristic;
BLEServer *pServer;
BLEService *pService;
BLEAdvertising *pAdvertising;
int state_wifi =-1;
//const int buttonPin = 16;

byte mac[]    = {  0xDE, 0xED, 0xBA, 0xFE, 0xFE, 0xED };

String valueChar="Renseignez vos identifiants wifi";
WiFiClient wifiClient;
PubSubClient client(wifiClient);

void setup() {
  Serial.begin(115200);
  pinMode(16, OUTPUT);
}

void setup_mqtt(){
  client.setServer("192.168.90.122", 1883);
  client.setCallback(callback);//Déclaration de la fonction de souscription
  reconnect();
}

void callback(char* topic, byte *payload, unsigned int length) {
   Serial.println("-------Nouveau message du broker mqtt-----");
   Serial.print("Canal:");
   Serial.println(topic);
   Serial.print("donnee:");
   Serial.write(payload, length);
   Serial.println();
   if ((char)payload[0] == '1') {
     Serial.println("LED ON");
      digitalWrite(16,HIGH); 
   } else {
     Serial.println("LED OFF");
     digitalWrite(16,LOW); 
   }
 }
void reconnect(){
  while (!client.connected()) {
    Serial.println("Connection au serveur MQTT ...");
    if (client.connect("esp")){
      Serial.println("MQTT connecté");
      client.subscribe("home/captor_values/2/action");//souscription au topic led pour commander une led
    }
    else {
      Serial.print("echec, code erreur= ");
      Serial.println(client.state());
      Serial.println("nouvel essai dans 2s");
    delay(2000);
    }
  }
}

void SM_s1_bluetooth() {  
    switch (state_wifi){
      case -1:
        BLEDevice::init("AirluxOG");
        pServer = BLEDevice::createServer();
        pService = pServer->createService(SERVICE_UUID);
        pCharacteristic = pService->createCharacteristic(
          CHARACTERISTIC_UUID,
          BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE
          );

        pCharacteristic->setValue("Renseignez vos identifiants wifi");
        pService->start();
        // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
        pAdvertising = BLEDevice::getAdvertising();
        pAdvertising->addServiceUUID(SERVICE_UUID);
        pAdvertising->setScanResponse(true);
        pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
        pAdvertising->setMinPreferred(0x12);
        BLEDevice::startAdvertising();
        state_wifi=0;
        break; // N'oubliez pas d'ajouter le "break" ici pour quitter le cas -1.

      case 0:
        
        if (String(pCharacteristic->getValue().c_str()) != valueChar) {
          String input = String(pCharacteristic->getValue().c_str());
          // Utilisez la fonction split pour séparer les parties
          String ssid, password;
          int commaIndex = input.indexOf(",");
          if (commaIndex != -1) {
            ssid = input.substring(0, commaIndex);
            password = input.substring(commaIndex + 1);
          } else {
            // Gérez le cas où il n'y a pas de virgule (valeur incorrecte)
            Serial.println("Valeur Bluetooth incorrecte - pas de virgule trouvée.");
            break;
          }

          Serial.print(F("Connecting to"));
          Serial.println(String(pCharacteristic->getValue().c_str()));
          Serial.println(ssid);
          Serial.print(password);              
          WiFi.begin(ssid, password);
          int timer=0;
          while (WiFi.status() != WL_CONNECTED && timer<20) {
            delay(500);
            Serial.print(".");
            timer++;
          }
          if(timer==20){
            valueChar=String(pCharacteristic->getValue().c_str());
            break;
          }
          Serial.println(F("WiFi connected, IP address: "));
          Serial.println(WiFi.localIP());
          IPAddress server(192, 168, 90, 122);
          if(Ping.ping(server)){
            Serial.println(F("Ping successful!!"));
          }
          setup_mqtt();
          client.publish("esp/test", "Hello from ESP32");
          state_wifi=1;
        }
        break; // N'oubliez pas d'ajouter le "break" ici pour quitter le cas 0.
      case 1:
        if(!client.connected()){
          reconnect();
        }
        client.loop(); 
        // Traitement pour l'état 1
        break; 
    }
}


void loop() {
    
  SM_s1_bluetooth();
  // put your main code here, to run repeatedly:
}