import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:airlux/screens/settings/automations/automations_screen.dart';
import 'package:airlux/screens/globals/models/automation.dart';
import 'package:airlux/screens/globals/models/automation_value.dart';
import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/globals/models/user.dart';
import 'package:airlux/screens/login_and_signup/login_screen.dart';
import 'package:airlux/screens/settings/management_screen.dart';
import 'package:airlux/screens/settings/profil_screen.dart';
import 'package:airlux/screens/settings/users/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:airlux/widgets/custom_card.dart';
import 'globals/models/captor.dart';
import 'globals/user_context.dart' as user_context;
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _subscription;
  Timer? timer;

  void setUIUp() {
    _selectedBuilding = user_context.buildings[0];
    _selectedRoom = user_context.rooms[0];

    setState(() {
      allCards.clear();
      for (int i = 0; i < user_context.captors.length; i++) {
        var building = user_context.buildings.firstWhere((element) =>
            element.id ==
            user_context.rooms
                .firstWhere(
                    (element) => element.id == user_context.captors[i].roomId)
                .buildingId);

        var room = user_context.rooms.firstWhere(
            (element) => element.id == user_context.captors[i].roomId);

        var ico = Icons.lightbulb;
        var icoOutlined = Icons.lightbulb_outline;

        var textOn = "Allumées";
        var textOff = "Éteintes";
        var switchval = true;
        var isValued = false;
        var val = "";

        switch (user_context.captors[i].type) {
          case CaptorType.light:
            ico = Icons.lightbulb;
            icoOutlined = Icons.lightbulb_outline;
            textOn = "Allumée";
            textOff = "Éteinte";
            switchval = user_context.captors[i].value == 1;
            break;
          case CaptorType.temp:
            ico = Icons.thermostat;
            icoOutlined = Icons.thermostat_outlined;
            textOn = "On";
            textOff = "Off";
            isValued = true;
            switchval = true;
            val = '${user_context.captors[i].value}°C';
            break;
          case CaptorType.door:
            ico = Icons.door_front_door;
            icoOutlined = Icons.door_front_door_outlined;
            textOn = "Ouverte";
            textOff = "Fermée";
            switchval = user_context.captors[i].value == 1;
            break;
          case CaptorType.shutter:
            ico = Icons.shutter_speed;
            icoOutlined = Icons.shutter_speed_outlined;
            textOn = "Ouvert";
            textOff = "Fermé";
            switchval = user_context.captors[i].value == 1;
            break;
          case CaptorType.move:
            ico = Icons.crisis_alert;
            icoOutlined = Icons.crisis_alert_outlined;
            textOn = "Alert";
            textOff = "Ok";
            switchval = user_context.captors[i].value == 1;
            break;
          default:
            ico = Icons.lightbulb;
        }

        allCards.add(CustomCard(
          icon: ico,
          outlinedIcon: icoOutlined,
          title: user_context.captors[i].name,
          subtitle: user_context.captors[i].name,
          value: val,
          pillTextOn: textOn,
          pillTextOff: textOff,
          switchValue: switchval,
          building: building.name,
          room: room.name,
          onSwitchChanged: (value) {
            widget.webSocketChannel.sink.add(
                'tocloud//captor_values//{"captor_id":"${user_context.captors[i].id}", "value": "${value == true ? 1.toString() : 0.toString()}"}//insert');
          },
          isValued: isValued,
        ));
      }
    });
  }

  void updateData() async {
    user_context.retrieveCaptorData(WebSocketChannel.connect(
        Uri.parse('ws://${user_context.serverIP}:6001')));

    while (!user_context.done) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    setUIUp();
  }

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (ModalRoute.of(context)!.isCurrent) {
        //job
        updateData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setUIUp();
    initTimer();
    //setUIUp();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel(); // Cancel the stream subscription
  }

  // Données pour le menu déroulant
  late Building? _selectedBuilding;

  // Index de la pièce sélectionnée
  bool everyRoom = true;
  late Room? _selectedRoom;

  // Tableau des cards
  List<CustomCard> allCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: user_context.buildings.isNotEmpty
            ? DropdownButton<String>(
                value: _selectedBuilding == null ? "" : _selectedBuilding!.name,
                onChanged: (String? newValue) {
                  setState(() {
                    if (_selectedBuilding == null) return;
                    for (int i = 0; i < user_context.buildings.length; i++) {
                      if (user_context.buildings[i].name == newValue) {
                        _selectedBuilding = user_context.buildings[i];
                      }
                    }
                  });
                },
                underline: Container(),
                items: user_context.buildings
                    .map<DropdownMenuItem<String>>((Building value) {
                  return DropdownMenuItem<String>(
                    value: value.name,
                    child: Text(value.name),
                  );
                }).toList(),
                style: Theme.of(context).textTheme.titleMedium,
                icon: const Icon(Icons.keyboard_arrow_down),
              )
            : const CircularProgressIndicator(),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     updateData();
          //   },
          // ),
          PopupMenuButton(
            icon: const Icon(Icons.settings),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Mon profil"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Gestion du parc"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Appareils"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Utillisateurs"),
                ),
                const PopupMenuItem(
                  value: 4,
                  child: Text("Automatisations"),
                ),
                const PopupMenuItem<int>(
                  value: 5,
                  child: Text("Deconnexion"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilScreen(),
                  ),
                );
              } else if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementScreen(),
                  ),
                );
              } else if (value == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),
                );
              } else if (value == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutomationsScreen(),
                  ),
                );
              } else if (value == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            // width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 20,
            child: user_context.rooms.isNotEmpty
                // &&
                //         user_context.rooms
                //             .where((element) =>
                //                 // ignore: unrelated_type_equality_checks
                //                 element.buildingId == _selectedBuilding)
                //             .isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: user_context.rooms
                            .where((element) =>
                                element.buildingId == _selectedBuilding!.id)
                            .length +
                        1,
                    itemBuilder: (BuildContext context, int index) {
                      final String roomName = index == 0
                          ? "Tout"
                          : user_context.rooms
                              .where((element) =>
                                  element.buildingId == _selectedBuilding!.id)
                              .toList()[index - 1]
                              .name;
                      final bool isSelected = roomName == "Tout" ||
                          roomName ==
                              user_context.rooms
                                  .where((element) =>
                                      element.buildingId ==
                                      _selectedBuilding!.id)
                                  .toList()[index - 1]
                                  .name;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              for (int i = 0;
                                  i < user_context.rooms.length;
                                  i++) {
                                if (roomName == "Tout") {
                                  everyRoom = true;
                                } else if (user_context.rooms[i].name ==
                                    roomName) {
                                  _selectedRoom = user_context.rooms[i];
                                  everyRoom = false;
                                }
                              }
                            });
                          },
                          child: Text(
                            roomName,
                            style: TextStyle(
                              color: isSelected ? Colors.teal : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const CircularProgressIndicator(), // Display a loading indicator,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      /* Focntionnement de l'affichage de la liste des cards :
                      - Si la pièce selectionée est "Tout" alors on affiche toutes les cartes
                      - Sinon on affiche que les cartes qui correspondent à la pièce selectionnée
                      */
                      everyRoom
                          ? allCards
                              .map((card) {
                                return CustomCard(
                                  icon: card.icon,
                                  outlinedIcon: card.outlinedIcon,
                                  title: card.title,
                                  subtitle: card.subtitle,
                                  value: card.value,
                                  pillTextOn: card.pillTextOn,
                                  pillTextOff: card.pillTextOff,
                                  switchValue: card.switchValue,
                                  building: card.building,
                                  room: card.room,
                                  onSwitchChanged: card.onSwitchChanged,
                                  isValued: card.isValued,
                                );
                              })
                              .where((card) =>
                                  card.building == _selectedBuilding!.name)
                              .toList()
                          : allCards
                              .map((card) {
                                return CustomCard(
                                  icon: card.icon,
                                  outlinedIcon: card.outlinedIcon,
                                  title: card.title,
                                  subtitle: card.subtitle,
                                  value: card.value,
                                  pillTextOn: card.pillTextOn,
                                  pillTextOff: card.pillTextOff,
                                  switchValue: card.switchValue,
                                  building: card.building,
                                  room: card.room,
                                  onSwitchChanged: card.onSwitchChanged,
                                  isValued: card.isValued,
                                );
                              })
                              .where((card) =>
                                  card.room == _selectedRoom!.name &&
                                  card.building == _selectedBuilding!.name)
                              .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
