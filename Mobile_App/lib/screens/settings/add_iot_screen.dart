import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final status = await Permission.bluetoothScan.request();
  if (status.isGranted) {
    final flutterBlue = FlutterBlue.instance;
    final bluetoothState = await flutterBlue.isOn;

    if (bluetoothState) {
      runApp(const MyApp());
    } else {
      print("Le Bluetooth n'est pas activé. Veuillez activer le Bluetooth.");
    }
  } else {
    print("Permission Bluetooth refusée");
  }
}
 class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
     return const MaterialApp(
      home: AddIotScreen(),
    );
  }
 }

class AddIotScreen extends StatefulWidget {
  const AddIotScreen({super.key});

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<AddIotScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startBluetoothScan();
  }

  void startBluetoothScan() async {
    
  final status = await Permission.bluetoothConnect.request();
  final statuScan = await Permission.bluetoothScan.request();

  if (status.isGranted && statuScan.isGranted) {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((scanResultList) {
      for (ScanResult scanResult in scanResultList) {
        if (scanResult.device.name == 'AirluxOG') {
          connectToBluetoothDevice(scanResult.device);
          break;
        }
      }
    });
  } else {
    print("Permission BLUETOOTH_CONNECT refusée");
  }
  }

  void connectToBluetoothDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      print("Connecté à ${device.name}");
    } catch (e) {
      print("Erreur de connexion à l'appareil Bluetooth : $e");
    }
  }

  void sendDataOverBluetooth() async {
    if (connectedDevice != null) {
      final id = idController.text;
      final password = passwordController.text;
      final serviceUuid = Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b');
      final characteristicUuid = Guid('beb5483e-36e1-4688-b7f5-ea07361b26a8');

      final services = await connectedDevice!.discoverServices();
      for (final service in services) {
        if (service.uuid == serviceUuid) {
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == characteristicUuid) {
              final dataToSend = utf8.encode("$id,$password");
              await characteristic.write(dataToSend, withoutResponse: true);
              print("Données envoyées avec succès à l'appareil Bluetooth");
              return;
            }
          }
        }
      }
      print("Caractéristique Bluetooth non trouvée dans le service");
    } else {
      print("Aucun appareil Bluetooth connecté.");
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (connectedDevice == null)
              const Text('Aucun appareil Bluetooth connecté')
            else
              Text('Connecté à: ${connectedDevice!.name}'),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true, // Pour masquer le mot de passe
            ),
            ElevatedButton(
              onPressed: sendDataOverBluetooth,
              child: const Text('Envoyer ID et mot de passe via Bluetooth'),
            ),
          ],
        ),
      ),
    );
  }
}
