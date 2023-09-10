import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:airlux/screens/automations_screen.dart';
import 'package:airlux/screens/ble_devices_screen.dart';
import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/palces_screen.dart';
import 'package:airlux/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:airlux/widgets/custom_card.dart';
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
  late List<Building> data;

  @override
  void initState() {
    super.initState();

    widget.webSocketChannel.sink.add(
        "tocloud//buildings//join{#}user_building ON buildings.id = user_building.building_id{#}where{#}user_id = ${user_context.userId}//get");

    // widget.webSocketChannel.sink.add(
    //     "tocloud//room//where{#} building_id IN buildings.id = user_building.building_id{#}where{#}user_id = ${user_context.userId}//get");

    _subscription = widget.webSocketChannel.stream.listen((message) {
      // Handle incoming message here
      Iterable l = json.decode(message);
      data = List<Building>.from(l.map((model) => Building.fromJson(model)));

      // Données pour le menu déroulant
      setState(() {
        _selectedBuilding = data[0];
        _buildings = data;

        // Index de la pièce sélectionnée
        _selectedRoomIndex = 0;
        _selectedRoom = 'Tout';
      });
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
  int _selectedRoomIndex = 0;
  String _selectedRoom = 'Tout';

  // Liste des pièces
  final List<String> _building1 = [
    'Tout',
    'Entrée',
    'Salon',
    'Cuisine',
    'Chambre 1',
    'Chambre 2',
    'Chambre 3'
  ];
  final List<String> _building2 = [
    'Tout',
    'Salon',
    'Cuisine',
    'Chambre 1',
    'Chambre 2',
    'Bureau'
  ];

  // Tableau des cards
  List<CustomCard> allCards = [
    CustomCard(
      icon: Icons.lightbulb,
      outlinedIcon: Icons.lightbulb_outline,
      title: "Lumières du salon",
      subtitle: "85 Lumières",
      pillTextOn: "Allumées",
      pillTextOff: "Éteintes",
      switchValue: true,
      building: "Bâtiment 1",
      room: "Salon",
      onSwitchChanged: (value) {},
    ),
    CustomCard(
      icon: Icons.sensor_window,
      outlinedIcon: Icons.sensor_window_outlined,
      title: "Volets",
      subtitle: "30 Volets",
      pillTextOn: "Fermés",
      pillTextOff: "Ouverts",
      switchValue: false,
      building: "Bâtiment 2",
      room: "Salon",
      onSwitchChanged: (value) {},
    ),
    CustomCard(
      icon: Icons.sensor_door,
      outlinedIcon: Icons.sensor_door_outlined,
      title: "Portes",
      subtitle: "10 Portes",
      pillTextOn: "Fermées",
      pillTextOff: "Ouvertes",
      switchValue: false,
      building: "Bâtiment 1",
      room: "Cuisine",
      onSwitchChanged: (value) {},
    ),
    CustomCard(
      icon: Icons.lightbulb,
      outlinedIcon: Icons.lightbulb_outline,
      title: "Lumières",
      subtitle: "2 Lumières",
      pillTextOn: "Allumées",
      pillTextOff: "Éteintes",
      switchValue: true,
      building: "Bâtiment 1",
      room: "Chambre 1",
      onSwitchChanged: (value) {},
    ),
    CustomCard(
      icon: Icons.sensor_window,
      outlinedIcon: Icons.sensor_window_outlined,
      title: "Volets",
      subtitle: "30 Volets",
      pillTextOn: "Fermés",
      pillTextOff: "Ouverts",
      switchValue: false,
      building: "Bâtiment 2",
      room: "Chambre 1",
      onSwitchChanged: (value) {},
    ),
    CustomCard(
      icon: Icons.sensor_door,
      outlinedIcon: Icons.sensor_door_outlined,
      title: "Portes",
      subtitle: "10 Portes",
      pillTextOn: "Fermées",
      pillTextOff: "Ouvertes",
      switchValue: false,
      building: "Bâtiment 2",
      room: "Chambre 2",
      onSwitchChanged: (value) {},
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Accueil'),
          title: _buildings != null && _buildings.isNotEmpty
              ? DropdownButton<String>(
                  value: _selectedBuilding.isUndefinedOrNull
                      ? ""
                      : _selectedBuilding!.name,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (_selectedBuilding.isUndefinedOrNull) return;
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
      // body: Column(
      //   children: [
      //     Container(
      //       // width: 100,
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       height: 20,
      //       child: _buildings != null && _buildings.isNotEmpty
      //           ? ListView.builder(
      //               scrollDirection: Axis.horizontal,
      //               itemCount: _selectedBuilding == 'Bâtiment 1'
      //                   ? _building1.length
      //                   : _building2.length,
      //               itemBuilder: (BuildContext context, int index) {
      //                 final String roomName = _selectedBuilding == 'Bâtiment 1'
      //                     ? _building1[index]
      //                     : _building2[index];
      //                 final bool isSelected = index == _selectedRoomIndex;
      //                 return Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //                   child: InkWell(
      //                     onTap: () {
      //                       setState(() {
      //                         _selectedRoomIndex = index;
      //                         _selectedRoom = roomName;
      //                       });
      //                     },
      //                     child: Text(
      //                       roomName,
      //                       style: TextStyle(
      //                         color: isSelected ? Colors.lime : Colors.black,
      //                         fontWeight: isSelected
      //                             ? FontWeight.bold
      //                             : FontWeight.normal,
      //                         fontSize: 16.0,
      //                       ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             )
      //           : CircularProgressIndicator(), // Display a loading indicator,
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Expanded(
      //       child: SafeArea(
      //         child: SingleChildScrollView(
      //           child: Column(
      //             children:
      //                 /* Focntionnement de l'affichage de la liste des cards :
      //                 - Si la pièce selectionée est "Tout" alors on affiche toutes les cartes
      //                 - Sinon on affiche que les cartes qui correspondent à la pièce selectionnée
      //                 */
      //                 _selectedRoom == "Tout"
      //                     ? allCards
      //                         .map((card) {
      //                           return CustomCard(
      //                               icon: card.icon,
      //                               outlinedIcon: card.outlinedIcon,
      //                               title: card.title,
      //                               subtitle: card.subtitle,
      //                               pillTextOn: card.pillTextOn,
      //                               pillTextOff: card.pillTextOff,
      //                               switchValue: card.switchValue,
      //                               building: card.building,
      //                               room: card.room,
      //                               onSwitchChanged: card.onSwitchChanged);
      //                         })
      //                         .where(
      //                             (card) => card.building == _selectedBuilding)
      //                         .toList()
      //                     : allCards
      //                         .map((card) {
      //                           return CustomCard(
      //                               icon: card.icon,
      //                               outlinedIcon: card.outlinedIcon,
      //                               title: card.title,
      //                               subtitle: card.subtitle,
      //                               pillTextOn: card.pillTextOn,
      //                               pillTextOff: card.pillTextOff,
      //                               switchValue: card.switchValue,
      //                               building: card.building,
      //                               room: card.room,
      //                               onSwitchChanged: card.onSwitchChanged);
      //                         })
      //                         .where((card) =>
      //                             card.room == _selectedRoom &&
      //                             card.building == _selectedBuilding)
      //                         .toList(),
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
