import 'dart:async';

import 'package:airlux/screens/globals/models/captor.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/settings/IOT/object_screen.dart';
import 'package:airlux/screens/settings/management_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import '../../globals/user_context.dart' as user_context;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/user_context.dart' as user_context;

import '../rooms/room_screen.dart';
import 'add_iot_screen.dart'; // Import your AddIotScreen

class AddCaptorScreen extends StatefulWidget {
  AddCaptorScreen({required this.room, super.key});

  Room room;
  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  State<StatefulWidget> createState() => AddCaptorScreenState();
}

class AddCaptorScreenState extends State<AddCaptorScreen> {
  StreamSubscription? _subscription;

  String? dropdownvalue = 'temp';

  var items = ['temp', 'light', 'door', 'shutter', 'move'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un objet'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Ajouter un objet',
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
              // Email field

              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  _subscription =
                      widget.webSocketChannel.stream.listen((message) async {
                    // Handle incoming message here
                    if (message.startsWith('{"id":')) {
                      user_context.retrieveData(WebSocketChannel.connect(
                          Uri.parse('ws://${user_context.serverIP}:6001')));

                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RoomScreen(widget.room),
                        ),
                      );
                    }
                  });

                  widget.webSocketChannel.sink.add(
                      'tocloud//captors//{"name": "${widget.nameController.text}","type": "${dropdownvalue}","room_id": ${widget.room.id}}//insert');
                },
                child: const Text('Ajouter un objet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
