import 'dart:async';

import 'package:flutter/material.dart';

import 'package:airlux/widgets/custom_textfield.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../globals/user_context.dart' as user_context;

import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

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
        title: const Text('AirLux'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bonjour
              Text(
                'Créer un compte !',
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

              // Forgot password
              TextButton(
                  onPressed: () {}, child: const Text('Mot de passe oublié')),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  _subscription = webSocketChannel.stream.listen((message) {
                    // Handle incoming message here
                    if (message.startsWith("OK")) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  });

                  webSocketChannel.sink.add(
                      'tocloud//users//{"name": "${nameController.text}","email": "${emailController.text}", "password": "${passwordController.text}"}//insert');
                },
                child: const Text('Inscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
