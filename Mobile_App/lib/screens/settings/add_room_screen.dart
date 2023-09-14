import 'dart:async';

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/settings/management_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../globals/user_context.dart' as user_context;

import 'add_iot_screen.dart';
import 'building_screen.dart'; // Import your AddIotScreen

class AddRoomScreen extends StatefulWidget {
  AddRoomScreen({required this.building, super.key});

  Building building;
  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  @override
  State<StatefulWidget> createState() => AddRoomScreenState();
}

class AddRoomScreenState extends State<AddRoomScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un batiment'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Ajouter un batiment',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 50),

              // Name field
              CustomTextfield(
                controller: widget.nameController,
                emailText: false,
                hintText: "Nom",
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
                      'tocloud//rooms//{"name": "${widget.nameController.text}","building_id": ${widget.building.id}}//insert');
                },
                child: const Text('Ajouter la pièce'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
