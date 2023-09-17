import 'dart:async';

import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/models/building.dart';
import '../../globals/user_context.dart' as user_context;
import '../IOT/connect_box_screen.dart';
import '../rooms/room_screen.dart'; // Import your RoomScreen
import '../rooms/add_room_screen.dart'; // Import your RoomScreen

class BuildingScreen extends StatefulWidget {
  BuildingScreen(this.building, {super.key});

  final Building building;

  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  State<StatefulWidget> createState() => BuildingScreenState();
}

class BuildingScreenState extends State<BuildingScreen> {
  StreamSubscription? _subscription;
  List<Widget> listRoom = [];

  String? dropdownvalue = "Large";
  var items = ['Large', 'Medium', 'Small'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.nameController.text = widget.building.name;
    dropdownvalue = widget.building.type;

    listRoom.add(
      ListTile(
        leading: const Icon(Icons.settings_input_antenna),
        title: Text("Connecter ma box"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConnectBoxScreen(
                  building: widget.building), // Navigate to ConnectBoxScreen
            ),
          );
        },
      ),
    );

    listRoom.add(
      const ListTile(
        leading: null,
        title: Text("Pièces"),
        enabled: false,
      ),
    );

    for (int i = 0; i < user_context.rooms.length; i++) {
      if (user_context.rooms[i].buildingId == widget.building.id) {
        listRoom.add(
          ListTile(
            leading: const Icon(Icons.window),
            title: Text(user_context.rooms[i].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(
                      user_context.rooms[i]), // Navigate to RoomScreen
                ),
              );
            },
          ),
        );
      }
    }
    listRoom.add(
      ListTile(
        leading: const Icon(Icons.add),
        title: Text("Ajouter une pièce"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoomScreen(
                  building: widget.building), // Navigate to RoomScreen
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerer le bâtiment"),
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
                    widget.building.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 50),
                  CustomTextfield(
                    controller: widget.nameController,
                    emailText: false,
                    hintText: widget.building.name,
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
                              builder: (context) =>
                                  BuildingScreen(widget.building),
                            ),
                          );
                        }
                      });

                      widget.webSocketChannel.sink.add(
                        'tocloud//buildings//{"id": ${widget.building.id}, "name": "${widget.nameController.text}", "type": "${dropdownvalue}", "user_id": ${user_context.userId}}//update',
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
                children: listRoom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
