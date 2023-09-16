import 'dart:async';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'buildings/building_screen.dart';
import 'buildings/add_building_screen.dart';

import '../globals/user_context.dart' as user_context;

class ManagementScreen extends StatelessWidget {
  ManagementScreen({super.key});

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    List<Widget> listBuildings = [];

    listBuildings.add(
      const ListTile(
        leading: null,
        title: Text("Bâtiments"),
        enabled: false,
      ),
    );

    for (int i = 0; i < user_context.buildings.length; i++) {
      listBuildings.add(ListTile(
        leading: Icon(user_context.buildings[i].type == "Large"
            ? Icons.apartment
            : user_context.buildings[i].type == "Medium"
                ? Icons.cottage
                : Icons.house),
        title: Text(user_context.buildings[i].name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuildingScreen(
                  user_context.buildings[i]), // Navigate to ProfilScreen
            ),
          );
        },
      ));
    }

    listBuildings.add(ListTile(
      leading: const Icon(Icons.add),
      title: Text("Ajouter un bâtiment"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddBuildingScreen(), // Navigate to ProfilScreen
          ),
        );
      },
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion batiments'),
      ),
      body: SafeArea(
        child: Column(
          children: listBuildings,
        ),
      ),
    );
  }
}
