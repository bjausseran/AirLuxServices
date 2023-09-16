import 'dart:async';

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/settings/management_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/user_context.dart' as user_context;

import '../IOT/add_iot_screen.dart';
import '../buildings/building_screen.dart'; // Import your AddIotScreen

class ConnectBoxScreen extends StatefulWidget {
  ConnectBoxScreen({required this.building, super.key});

  Building building;
  // Text editing controllers
  final SSIDController = TextEditingController();
  final passwordController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  @override
  State<StatefulWidget> createState() => AddConnectBoxScreenState();
}

class AddConnectBoxScreenState extends State<ConnectBoxScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connecter ma box'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Entrer les identifiants du réseau Wifi',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 50),

              // SSID field
              CustomTextfield(
                controller: widget.SSIDController,
                emailText: false,
                hintText: "SSID",
                obscureText: false,
              ),

              const SizedBox(height: 20),
              // Pass field
              CustomTextfield(
                controller: widget.SSIDController,
                emailText: false,
                hintText: "Password",
                obscureText: false,
              ),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  _subscription =
                      widget.webSocketChannel.stream.listen((message) {
                    // Handle incoming message here
                    if (message.startsWith("OK")) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BuildingScreen(widget.building),
                        ),
                      );
                    }
                  });

                  widget.webSocketChannel.sink.add(
                      'tocloud//connectbox//{"SSID": "${widget.SSIDController.text}","password": "${widget.passwordController.text},"building_id": ${widget.building}}');
                },
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
