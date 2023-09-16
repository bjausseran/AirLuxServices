import 'dart:async';

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/settings/management_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import '../../globals/user_context.dart' as user_context;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/user_context.dart' as user_context;

import '../IOT/add_iot_screen.dart'; // Import your AddIotScreen

class AddBuildingScreen extends StatefulWidget {
  AddBuildingScreen({super.key});

  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  @override
  State<StatefulWidget> createState() => AddBuildingScreenState();
}

class AddBuildingScreenState extends State<AddBuildingScreen> {
  StreamSubscription? _subscription;

  String? dropdownvalue = 'Large';

  var items = ['Large', 'Medium', 'Small'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un bâtiment'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Ajouter un bâtiment',
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
                icon: Icon(Icons.keyboard_arrow_down),
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
                      widget.webSocketChannel.stream.listen((message) {
                    // Handle incoming message here
                    if (message.startsWith("OK")) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ManagementScreen(),
                        ),
                      );
                    }
                  });

                  widget.webSocketChannel.sink.add(
                      'tocloud//buildings//{"name": "${widget.nameController.text}","type": "${dropdownvalue}","user_id": ${user_context.userId}}//insert');
                },
                child: const Text('Ajouter un bâtiment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
