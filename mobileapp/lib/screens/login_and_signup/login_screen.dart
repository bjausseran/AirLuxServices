import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:airlux/screens/home_screen.dart';
import 'package:airlux/screens/login_and_signup/signup_screen.dart';
import 'package:airlux/widgets/custom_textfield.dart';
import '../globals/user_context.dart' as user_context;

class LoginScreen extends StatefulWidget {
  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription? _subscription;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    widget.webSocketChannel.sink.close();
  }

  Future<void> goToHomeScreen({context = BuildContext}) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

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
              // Texte de bienvenue
              Text(
                'Connectez vous !!',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 50),

              // Email field
              CustomTextfield(
                key: const ValueKey('email_field'),
                controller: emailController,
                emailText: true,
                hintText: 'E-mail',
                obscureText: false,
              ),

              const SizedBox(height: 20),

              // Password field
              CustomTextfield(
                key: const ValueKey('password_field'),
                controller: passwordController,
                emailText: false,
                hintText: 'Mot de passe',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Forgot password
              TextButton(
                  key: const ValueKey('forgot_password_button'),
                  onPressed: () {},
                  child: const Text('Mot de passe oublié')),

              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                key: const ValueKey('login_button'),
                onPressed: () {
                  _subscription =
                      widget.webSocketChannel.stream.listen((message) {
                    // Handle incoming message here
                    if (message.startsWith("connection//true//")) {
                      var id = int.parse(message.substring(18));
                      user_context.userId = id;

                      goToHomeScreen(context: context);
                    }
                  });

                  widget.webSocketChannel.sink.add(
                      "connect//user//${emailController.text}{#}${passwordController.text}");
                },
                child: const Text('Connexion'),
              ),

              const SizedBox(height: 50),
              // Create account
              TextButton(
                key: const ValueKey('create_account_button'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: const Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
