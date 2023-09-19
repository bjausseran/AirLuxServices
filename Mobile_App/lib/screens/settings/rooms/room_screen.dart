import 'dart:async';

import 'package:airlux/screens/settings/IOT/add_iot_screen.dart';
import 'package:airlux/screens/settings/rooms/add_room_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/models/captor.dart';
import '../../globals/models/room.dart';
import '../../globals/user_context.dart' as user_context;
import '../IOT/add_captor.dart';
import '../IOT/object_screen.dart';

class RoomScreen extends StatefulWidget {
  RoomScreen(this.room, {super.key});

  final Room room;

  // Text editing controllers
  final nameController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  State<StatefulWidget> createState() => RoomScreenState();
}

class RoomScreenState extends State<RoomScreen> {
  StreamSubscription? _subscription;
  List<Widget> listCaptor = [];

  String? dropdownvalue = "Large";
  var items = ['Large', 'Medium', 'Small'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.nameController.text = widget.room.name;

    listCaptor.add(
      const ListTile(
        leading: null,
        title: Text("Objets connectés"),
        enabled: false,
      ),
    );

    for (int i = 0; i < user_context.captors.length; i++) {
      if (user_context.captors[i].roomId == widget.room.id) {
        var ico = Icons.broadcast_on_home;

        switch (user_context.captors[i].type) {
          case CaptorType.light:
            ico = Icons.lightbulb;
            break;
          case CaptorType.temp:
            ico = Icons.thermostat;
            break;
          case CaptorType.door:
            ico = Icons.door_front_door;
            break;
          case CaptorType.shutter:
            ico = Icons.shutter_speed;
            break;
          case CaptorType.move:
            ico = Icons.crisis_alert;
            break;
          default:
            ico = Icons.lightbulb;
        }

        listCaptor.add(
          ListTile(
            leading: Icon(ico),
            title: Text(user_context.captors[i].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaptorScreen(
                      user_context.captors[i]), // Navigate to RoomScreen
                ),
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerer la pièce"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Form Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.room.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 50),
                  CustomTextfield(
                    controller: widget.nameController,
                    emailText: false,
                    hintText: widget.room.name,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _subscription = widget.webSocketChannel.stream
                          .listen((message) async {
                        // Handle incoming message here
                        if (message.startsWith("OK")) {
                          user_context.retrieveData(WebSocketChannel.connect(
                              Uri.parse('ws://${user_context.serverIP}:6001')));

                          await Future.delayed(const Duration(seconds: 2));

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RoomScreen(
                                  user_context.rooms.firstWhere((element) =>
                                      element.id == widget.room.id)),
                            ),
                          );
                        }
                      });

                      widget.webSocketChannel.sink.add(
                        'tocloud//rooms//{"name": "${widget.nameController.text}","building_id": ${widget.room.buildingId}, "id": ${widget.room.id}}//update',
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
                children: listCaptor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddCaptorScreen(room: widget.room), // Navigate to RoomScreen
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
