import 'dart:async';

import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../login_and_signup/login_screen.dart';
import 'profil_screen.dart';
import 'management_screen.dart';
import 'add_iot_screen.dart'; // Import your AddIotScreen

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilScreen(), // Navigate to ProfilScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.broadcast_on_personal),
              title: const Text('Gestion du parc'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManagementScreen(), // Navigate to AddIotScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Deconnexion'),
              onTap: () {
                // Implement your log out logic here
                // For example, you can show a confirmation dialog and log the user out
                // You might also want to clear any user-related data and navigate to the login screen
                // For now, let's navigate to the LoginScreen directly
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(), // Navigate to LoginScreen
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
