library airlux.globals.user_context;

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models/captor.dart';

var done = false;

StreamSubscription? _subscription;

int userId = -1;
//String serverIP = "localhost";
String serverIP = "192.168.196.72";

List<Building> buildings = List.empty(growable: true);
List<Room> rooms = List.empty(growable: true);
List<Captor> captors = List.empty(growable: true);

Future<bool> getAllData(WebSocketChannel webSocketChannel) async {
  if (_subscription.isNull) {
    _subscription ??= webSocketChannel.stream.listen((message) {
      // Données pour le menu déroulant
      //try {
      if (buildings.isEmpty) {
        // Handle incoming message here
        Iterable l = json.decode(message);
        buildings =
            List<Building>.from(l.map((model) => Building.fromJson(model)));

        var str = "(";
        for (int i = 0; i < buildings.length; i++) {
          str += buildings[i].id.toString();
          if (i != buildings.length - 1) {
            str += ", ";
          }
        }
        str += ")";

        webSocketChannel.sink
            .add("tocloud//rooms//where{#}building_id IN $str//get");
      } else if (rooms.isEmpty) {
        // Handle incoming message here
        Iterable l = json.decode(message);
        rooms = List<Room>.from(l.map((model) => Room.fromJson(model)));

        var str = "(";
        for (int i = 0; i < buildings.length; i++) {
          str += buildings[i].id.toString();
          if (i != buildings.length - 1) {
            str += ", ";
          }
        }
        str += ")";

        webSocketChannel.sink
            .add("tocloud//captors//where{#}room_id IN $str//get");
      } else {
        // Handle incoming message here
        Iterable l = json.decode(message);
        captors = List<Captor>.from(l.map((model) => Captor.fromJson(model)));

        done = true;
      }
    });
  }

  // } catch (e) {
  //   //stderr.writeln(e);
  // }

  webSocketChannel.sink.add(
      "tocloud//buildings//join{#}user_building ON buildings.id = user_building.building_id{#}where{#}user_id = ${userId}//get");

  while (!done) {
    Future.delayed(const Duration(milliseconds: 500), () {
      return true;
    });
  }

  return done;
}
