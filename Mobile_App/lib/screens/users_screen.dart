import 'package:airlux/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'globals/user_context.dart' as user_context;

import '../widgets/custom_textfield.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

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
  // Tableau des cards
  // List<CustomCard> cards = [
  //   CustomCard(
  //       icon: Icons.person,
  //       outlinedIcon: Icons.person_outline,
  //       value: "",
  //       title: "Aymeric Queret",
  //       subtitle: "Autres informations",
  //       pillTextOn: "Autorisé",
  //       pillTextOff: "Non autorisé",
  //       switchValue: true,
  //       onSwitchChanged: (bool) {},
  //       isValued: false),
  //   CustomCard(
  //       icon: Icons.person,
  //       outlinedIcon: Icons.person_outline,
  //       value: "",
  //       title: "Benoît Jausseran",
  //       subtitle: "Autres informations",
  //       pillTextOn: "Autorisé",
  //       pillTextOff: "Non autorisé",
  //       switchValue: true,
  //       onSwitchChanged: (bool) {},
  //       isValued: false),
  //   CustomCard(
  //       icon: Icons.person,
  //       outlinedIcon: Icons.person_outline,
  //       value: "",
  //       title: "Artus Pouillet",
  //       subtitle: "Autres informations",
  //       pillTextOn: "Autorisé",
  //       pillTextOff: "Non autorisé",
  //       switchValue: true,
  //       onSwitchChanged: (bool) {},
  //       isValued: false),
  // ];

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
          switchValue: true,
          onSwitchChanged: (bool) {},
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
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Wrap(
                    // height: 200.0,
                    // color: Colors.white,

                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Form(
                                child: Column(
                              children: <Widget>[
                                CustomTextfield(
                                  controller: lastNameController,
                                  emailText: false,
                                  hintText: 'Nom',
                                  obscureText: false,
                                ),

                                const SizedBox(height: 20),

                                CustomTextfield(
                                  controller: firstNameController,
                                  emailText: false,
                                  hintText: 'Prénom',
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
                              ],
                            )),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Ajouter'),
                            ),
                          ],
                        ),
                      ),
                    ]),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
