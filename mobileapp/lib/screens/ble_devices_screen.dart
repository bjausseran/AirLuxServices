import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleDevices extends StatefulWidget {
  const BleDevices({super.key});

  @override
  State<BleDevices> createState() => _BleDevicesState();
}

class _BleDevicesState extends State<BleDevices> {
  // Variables
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> devices = [];
  List<String> deviceName = [];
  bool isConnected = false;
  dynamic subscription;
  bool buttonEnabled = true;

  // Functions
  void startScan() {
    setState(() {
      buttonEnabled = false;
    });
    devices.clear();
    deviceName.clear();
    // print("Scanning ...");
    Timer(const Duration(seconds: 4), () {
      stopScan();
    });
    subscription = flutterReactiveBle.scanForDevices(
        scanMode: ScanMode.lowLatency, withServices: []).listen((device) {
      // Scan for handling results
      if (device.name.isNotEmpty && !deviceName.contains(device.name)) {
        setState(() {
          // print(device);
          deviceName.add(device.name);
          devices.add(device);
        });
      }
    }, onError: (Object error) {});
  }

  void stopScan() {
    subscription?.cancel();
    subscription = null;
    // print('Scan stoped after 4 seconds');
    setState(() {
      buttonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appareils'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            // onPressed: () {
            //   startScan();
            // },
            onPressed: () {
              if (buttonEnabled) {
                startScan();
              }
              Null;
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${devices[index].name} | ${devices[index].rssi}'),
            trailing: ElevatedButton(
                onPressed: () {
                  if (isConnected == false) {
                    // connect(devices[index]);
                  } else {
                    // disconnect(devices[index]);
                  }
                },
                child: isConnected == false
                    ? const Text('Connecter')
                    : const Text('Déconnecter')),
          );
        },
      ),
    );
  }
}
