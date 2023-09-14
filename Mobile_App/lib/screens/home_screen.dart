import 'dart:async';
import 'dart:convert';

import 'package:airlux/screens/automations_screen.dart';
import 'package:airlux/screens/ble_devices_screen.dart';
import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/palces_screen.dart';
import 'package:airlux/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:airlux/widgets/custom_card.dart';
import 'globals/models/captor.dart';
import 'globals/user_context.dart' as user_context;

class HomeScreen extends StatefulWidget {
  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    widget.webSocketChannel.sink.add(
        "tocloud//buildings//join{#}user_building ON buildings.id = user_building.building_id{#}where{#}user_id = ${user_context.userId}//get");

    _subscription = widget.webSocketChannel.stream.listen((message) {
      // Données pour le menu déroulant
      try {
        if (_buildings.isEmpty) {
          // Handle incoming message here
          Iterable l = json.decode(message);
          var data =
              List<Building>.from(l.map((model) => Building.fromJson(model)));

          setState(() {
            _selectedBuilding = data[0];
            _buildings = data;
          });

          var str = "(";
          for (int i = 0; i < _buildings.length; i++) {
            str += _buildings[i].id.toString();
            if (i != _buildings.length - 1) {
              str += ", ";
            }
          }
          str += ")";

          widget.webSocketChannel.sink
              .add("tocloud//rooms//where{#}building_id IN $str//get");
        } else if (_rooms.isEmpty) {
          // Handle incoming message here
          Iterable l = json.decode(message);
          var data = List<Room>.from(l.map((model) => Room.fromJson(model)));

          setState(() {
            _selectedRoom = data[0];
            _rooms = data;
          });

          var str = "(";
          for (int i = 0; i < _buildings.length; i++) {
            str += _buildings[i].id.toString();
            if (i != _buildings.length - 1) {
              str += ", ";
            }
          }
          str += ")";

          widget.webSocketChannel.sink
              .add("tocloud//captors//where{#}room_id IN $str//get");
        } else {
          // Handle incoming message here
          Iterable l = json.decode(message);
          var data =
              List<Captor>.from(l.map((model) => Captor.fromJson(model)));

          setState(() {
            _captors = data;
            allCards.clear();
            for (int i = 0; i < _captors.length; i++) {
              var building = _buildings.firstWhere((element) =>
                  element.id ==
                  _rooms
                      .firstWhere((element) => element.id == _captors[i].roomId)
                      .buildingId);

              var room = _rooms
                  .firstWhere((element) => element.id == _captors[i].roomId);

              var ico = Icons.lightbulb;
              var ico_outlined = Icons.lightbulb_outline;

              var textOn = "Allumées";
              var textOff = "Éteintes";
              var switchval = true;
              var val = "";

              switch (_captors[i].type) {
                case CaptorType.light:
                  ico = Icons.lightbulb;
                  ico_outlined = Icons.lightbulb_outline;
                  textOn = "Allumée";
                  textOff = "Éteinte";
                  switchval = _captors[i].value == 1;
                  break;
                case CaptorType.temp:
                  ico = Icons.thermostat;
                  ico_outlined = Icons.thermostat_outlined;
                  textOn = "On";
                  textOff = "Off";
                  switchval = true;
                  val = _captors[i].value.toString();
                  break;
                case CaptorType.door:
                  ico = Icons.door_front_door;
                  ico_outlined = Icons.door_front_door_outlined;
                  textOn = "Ouverte";
                  textOff = "Fermée";
                  switchval = _captors[i].value == 1;
                  break;
                case CaptorType.shutter:
                  ico = Icons.shutter_speed;
                  ico_outlined = Icons.shutter_speed_outlined;
                  textOn = "Ouvert";
                  textOff = "Fermé";
                  switchval = _captors[i].value == 1;
                  break;
                case CaptorType.move:
                  ico = Icons.crisis_alert;
                  ico_outlined = Icons.crisis_alert_outlined;
                  textOn = "Alert";
                  textOff = "Ok";
                  switchval = _captors[i].value == 1;
                  break;
                default:
                  ico = Icons.lightbulb;
              }

              allCards.add(CustomCard(
                icon: ico,
                outlinedIcon: ico_outlined,
                title: _captors[i].name,
                subtitle: _captors[i].name,
                value: val,
                pillTextOn: textOn,
                pillTextOff: textOff,
                switchValue: switchval,
                building: building.name,
                room: room.name,
                onSwitchChanged: (value) {
                  widget.webSocketChannel.sink.add(
                      'tocloud//captor_values//{"captor_id":"${_captors[i].id}", "value": "${value == true ? 1.toString() : 0.toString()}"}//insert');
                },
              ));
            }
          });
        }
      } catch (e) {
        //stderr.writeln(e);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel(); // Cancel the stream subscription
  }

  // Données pour le menu déroulant
  late Building? _selectedBuilding;
  late List<Building> _buildings = List.empty(growable: true);

  // Index de la pièce sélectionnée
  bool everyRoom = true;
  late Room? _selectedRoom;
  late List<Room> _rooms = List.empty(growable: true);

  late List<Captor> _captors = List.empty(growable: true);

  // Tableau des cards
  List<CustomCard> allCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Accueil'),
          title: _buildings.isNotEmpty
              ? DropdownButton<String>(
                  value:
                      _selectedBuilding == null ? "" : _selectedBuilding!.name,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (_selectedBuilding == null) return;
                      for (int i = 0; i < _buildings.length; i++) {
                        if (_buildings[i].name == newValue) {
                          _selectedBuilding = _buildings[i];
                        }
                      }
                    });
                  },
                  underline: Container(),
                  items: _buildings
                      .map<DropdownMenuItem<String>>((Building value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name),
                    );
                  }).toList(),
                  style: Theme.of(context).textTheme.titleLarge,
                  icon: const Icon(Icons.keyboard_arrow_down),
                )
              : CircularProgressIndicator(), // Display a loading indicator,
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
                icon: const Icon(Icons.add_box_outlined),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Appareils"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Lieux"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Utillisateurs"),
                    ),
                    const PopupMenuItem(
                        value: 3, child: Text("Automatisations"))
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BleDevices()),
                    );
                  } else if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlacesScreen()),
                    );
                  } else if (value == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UsersScreen()),
                    );
                  } else if (value == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AutomationsScreen()),
                    );
                  }
                })
          ]),
      body: Column(
        children: [
          Container(
            // width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 20,
            child: _rooms.isNotEmpty
                // &&
                //         _rooms
                //             .where((element) =>
                //                 // ignore: unrelated_type_equality_checks
                //                 element.buildingId == _selectedBuilding)
                //             .isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _rooms
                            .where((element) =>
                                element.buildingId == _selectedBuilding!.id)
                            .length +
                        1,
                    itemBuilder: (BuildContext context, int index) {
                      final String roomName = index == 0
                          ? "Tout"
                          : _rooms
                              .where((element) =>
                                  element.buildingId == _selectedBuilding!.id)
                              .toList()[index - 1]
                              .name;
                      final bool isSelected = roomName == "Tout" ||
                          roomName ==
                              _rooms
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
                              for (int i = 0; i < _rooms.length; i++) {
                                if (roomName == "Tout") {
                                  everyRoom = true;
                                } else if (_rooms[i].name == roomName) {
                                  _selectedRoom = _rooms[i];
                                  everyRoom = false;
                                }
                              }
                            });
                          },
                          child: Text(
                            roomName,
                            style: TextStyle(
                              color: isSelected ? Colors.lime : Colors.black,
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
                : CircularProgressIndicator(), // Display a loading indicator,
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
                                    onSwitchChanged: card.onSwitchChanged);
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
                                    onSwitchChanged: card.onSwitchChanged);
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
