import 'dart:convert';
import 'package:airlux/screens/globals/models/captor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/custom_textfield.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final status = await Permission.bluetoothScan.request();
//   if (status.isGranted) {
//     final flutterBlue = FlutterBlue.instance;
//     final bluetoothState = await flutterBlue.isOn;

//     if (bluetoothState) {
//       runApp(const MyApp());
//     } else {
//       print("Le Bluetooth n'est pas activé. Veuillez activer le Bluetooth.");
//     }
//   } else {
//     print("Permission Bluetooth refusée");
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: AddIotScreen(captor: null,),
//     );
//   }
// }

class AddIotScreen extends StatefulWidget {
  AddIotScreen({required this.captor, super.key});

  Captor captor;
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<AddIotScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> checkBluetootPermission() async {
    WidgetsFlutterBinding.ensureInitialized();
    final status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      final flutterBlue = FlutterBlue.instance;
      final bluetoothState = await flutterBlue.isOn;

      if (bluetoothState) {
        startBluetoothScan();
      } else {
        print("Le Bluetooth n'est pas activé. Veuillez activer le Bluetooth.");
      }
    } else {
      print("Permission Bluetooth refusée");
    }
  }

  @override
  void initState() {
    super.initState();
    checkBluetootPermission();
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
      final id = ssidController.text;
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
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Connecter l'objet"),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (connectedDevice == null)
                  const Text('Aucun appareil Bluetooth connecté')
                else
                  Text('Connecté à: ${connectedDevice!.name}'),

                const SizedBox(height: 50),

                // Name field
                CustomTextfield(
                  controller: ssidController,
                  emailText: false,
                  hintText: "SSID",
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                // Name field
                CustomTextfield(
                  controller: passwordController,
                  emailText: false,
                  hintText: "Mot de passe",
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: sendDataOverBluetooth,
                  child: const Text("Connecter l'objet"),
                ),
              ],
            ),
          ),
        ));
  }
}
