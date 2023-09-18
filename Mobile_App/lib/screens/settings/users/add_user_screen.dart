import 'dart:async';
import 'dart:convert';

import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/settings/users/users_screen.dart';
import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/models/user.dart';
import '../../globals/user_context.dart' as user_context;

import '../IOT/add_iot_screen.dart'; // Import your AddIotScreen

class AddUserScreen extends StatelessWidget {
  AddUserScreen({super.key});

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un utilisateur'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Ajouter un utilisateur',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 50),

              // Name field
              CustomTextfield(
                controller: nameController,
                emailText: true,
                hintText: 'Nom',
                obscureText: false,
              ),

              const SizedBox(height: 20),
              // Email field
              CustomTextfield(
                controller: emailController,
                emailText: true,
                hintText: 'E-mail',
                obscureText: false,
              ),

              const SizedBox(height: 20),

              // Password field
              CustomTextfield(
                controller: passwordController,
                emailText: false,
                hintText: 'Mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Check password field
              CustomTextfield(
                controller: passwordController,
                emailText: false,
                hintText: 'Confirmer le mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  _subscription = webSocketChannel.stream.listen((message) {
                    // Handle incoming message here
                    if (message.startsWith("OK")) {}
                    if (message.startsWith('{"id":')) {
                      var id = message.split(": ")[1];
                      id = id.substring(0, id.length - 1);

                      for (int i = 0; i < user_context.buildings.length; i++) {
                        webSocketChannel.sink.add(
                            'tocloud//buildings//{"building_id": ${user_context.buildings[i].id},"user_id": $id}//conn');
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UsersScreen(),
                        ),
                      );
                    }
                  });

                  webSocketChannel.sink.add(
                      'tocloud//users//{"name": "${nameController.text}","email": "${emailController.text}", "password": "${passwordController.text}", "id": "${user_context.userId}", "authorized" : 1}//insert');

                  webSocketChannel.sink.add(
                      'tocloud//users//where{#}users.email = "${emailController.text}"//get');
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
