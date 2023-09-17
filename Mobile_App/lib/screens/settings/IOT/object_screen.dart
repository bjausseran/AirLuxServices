import 'dart:async';

import 'package:airlux/screens/settings/IOT/add_iot_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/models/captor.dart';
import '../../globals/user_context.dart' as user_context;

class CaptorScreen extends StatefulWidget {
  CaptorScreen(this.captor, {super.key});

  final Captor captor;

  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  State<StatefulWidget> createState() => CaptorScreenState();
}

class CaptorScreenState extends State<CaptorScreen> {
  StreamSubscription? _subscription;
  List<Widget> listButton = [];

  String? dropdownvalue = "temp";
  var items = ['temp', 'light', 'door', 'shutter', 'move'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.nameController.text = widget.captor.name;
    dropdownvalue = widget.captor.type.toString().split('.').last;
    listButton.add(
      ListTile(
        leading: const Icon(Icons.settings_input_antenna),
        title: Text("Connecter l'object"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddIotScreen(
                captor: widget.captor,
              ), // Navigate to ConnectBoxScreen
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerer l'object connecté"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Form Section
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.captor.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 50),
                  CustomTextfield(
                    controller: widget.nameController,
                    emailText: false,
                    hintText: widget.captor.name,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButton(
                      isExpanded: true,
                      value: dropdownvalue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: items.map((items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _subscription =
                          widget.webSocketChannel.stream.listen((message) {
                        // Handle incoming message here
                        if (message.startsWith("OK")) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CaptorScreen(widget.captor),
                            ),
                          );
                        }
                      });

                      widget.webSocketChannel.sink.add(
                        'tocloud//captors//{"id": ${widget.captor.id}, "name": "${widget.nameController.text}", "type": "${dropdownvalue}", "value": ${widget.captor.value}, "roomId": ${widget.captor.roomId}}//update',
                      );
                    },
                    child: const Text('Mettre à jour'),
                  ),
                ],
              ),
            ),
            // List Section
            Expanded(
              child: ListView(
                children: listButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
