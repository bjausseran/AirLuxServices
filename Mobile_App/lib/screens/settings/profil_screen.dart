import 'dart:async';

import 'package:airlux/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../globals/models/user.dart';
import '../globals/user_context.dart' as user_context;

import 'IOT/add_iot_screen.dart'; // Import your AddIotScreen

class ProfilScreen extends StatefulWidget {
  ProfilScreen({super.key});

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  StreamSubscription? _subscription;
  @override
  State<StatefulWidget> createState() => ProfilScreenState();
}

class ProfilScreenState extends State<ProfilScreen> {
  StreamSubscription? _subscription;
  List<Widget> listButton = [];

  @override
  Widget build(BuildContext context) {
    User? user;
    for (int i = 0; i < user_context.users.length; i++) {
      if (user_context.users[i].id == user_context.userId) {
        widget.nameController.text = user_context.users[i].name;
        widget.emailController.text = user_context.users[i].email;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Modifier mon profil',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 50),

              // Name field
              CustomTextfield(
                controller: widget.nameController,
                emailText: true,
                hintText: 'Nom',
                obscureText: false,
              ),

              const SizedBox(height: 20),
              // Email field
              CustomTextfield(
                controller: widget.emailController,
                emailText: true,
                hintText: 'E-mail',
                obscureText: false,
              ),

              const SizedBox(height: 20),

              // Password field
              CustomTextfield(
                controller: widget.passwordController,
                emailText: false,
                hintText: 'Mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Check password field
              CustomTextfield(
                controller: widget.passwordController,
                emailText: false,
                hintText: 'Confirmer le mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  _subscription =
                      widget.webSocketChannel.stream.listen((message) async {
                    // Handle incoming message here
                    if (message.startsWith("OK")) {
                      user_context.retrieveData(WebSocketChannel.connect(
                          Uri.parse('ws://${user_context.serverIP}:6001')));

                      while (!user_context.done) {
                        await Future.delayed(const Duration(milliseconds: 100));
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfilScreen(),
                        ),
                      );
                    }
                  });

                  widget.webSocketChannel.sink.add(
                      'tocloud//users//{"name": "${widget.nameController.text}","email": "${widget.emailController.text}", "password": "${widget.passwordController.text}", "authorized": 1, "id": "${user_context.userId}"}//update');
                },
                child: const Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
