import 'dart:async';

import 'package:airlux/screens/settings/users/add_user_screen.dart';
import 'package:airlux/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../globals/user_context.dart' as user_context;

import '../../../widgets/custom_textfield.dart';

class UsersScreen extends StatefulWidget {
  UsersScreen({super.key});

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  late List<CustomCard> cards = List.empty(growable: true);

  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < user_context.users.length; i++) {
      cards.add(CustomCard(
          icon: Icons.person,
          outlinedIcon: Icons.person_outline,
          value: "",
          title: user_context.users[i].name,
          subtitle: user_context.users[i].email,
          pillTextOn: "Autorisé",
          pillTextOff: "Non autorisé",
          switchValue: user_context.users[i].authorized,
          onSwitchChanged: (bool) {
            widget.webSocketChannel.sink.add(
                'tocloud//users//{"name": "${user_context.users[i].name}","email": "${user_context.users[i].email}", "authorized": ${bool ? 1 : 0}, "password": "pass", "id": "${user_context.users[i].id}"}//update');
          },
          isValued: false));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            final card = cards[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  cards.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Text(
                      'Utilisateur supprimé',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                );
              },
              background: Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
              ),
              child: card,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
