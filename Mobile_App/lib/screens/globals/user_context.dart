library airlux.globals.user_context;

import 'dart:convert';
import 'dart:io';

import 'package:airlux/screens/globals/models/automation.dart';
import 'package:airlux/screens/globals/models/automation_value.dart';
import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/globals/models/user.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'models/captor.dart';

int userId = -1;
String serverIP = "localhost";
//String serverIP = "192.168.196.72";

List<Building> buildings = List.empty(growable: true);
List<Room> rooms = List.empty(growable: true);
List<Captor> captors = List.empty(growable: true);
List<User> users = List.empty(growable: true);
List<Automation> automations = List.empty(growable: true);
List<AutomationValue> automationValues = List.empty(growable: true);

String concatBuildingsId() {
  var str = "(";
  for (int i = 0; i < buildings.length; i++) {
    str += buildings[i].id.toString();
    if (i != buildings.length - 1) str += ",";
  }
  str += ")";
  return str;
}

String concatRoomsId() {
  var str = "(";
  for (int i = 0; i < rooms.length; i++) {
    str += rooms[i].id.toString();
    if (i != rooms.length - 1) str += ",";
  }
  str += ")";
  return str;
}

String concatAutomationsId() {
  var str = "(";
  for (int i = 0; i < automations.length; i++) {
    str += automations[i].id.toString();
    if (i != automations.length - 1) str += ",";
  }
  str += ")";
  return str;
}

String concatUsersId() {
  var str = "(";
  for (int i = 0; i < users.length; i++) {
    str += users[i].id.toString();
    if (i != users.length - 1) str += ",";
  }
  str += ")";
  return str;
}

void retrieveData(WebSocketChannel webSocketChannel) {
  buildings.clear();
  rooms.clear();
  captors.clear();
  users.clear();
  automations.clear();
  automationValues.clear();

  webSocketChannel.sink.add(
      "tocloud//buildings//join{#}user_building ON buildings.id = user_building.building_id{#}where{#}user_id = $userId//get");

  webSocketChannel.stream.listen((message) {
    // Données pour le menu déroulant
    try {
      if (buildings.isEmpty) {
        // Handle incoming message here
        Iterable l = json.decode(message);
        var data =
            List<Building>.from(l.map((model) => Building.fromJson(model)));
        buildings = data;
        webSocketChannel.sink.add(
            "tocloud//rooms//where{#}building_id IN  ${concatBuildingsId()}//get");
      } else if (rooms.isEmpty) {
        // Handle incoming message here
        Iterable l = json.decode(message);
        var data = List<Room>.from(l.map((model) => Room.fromJson(model)));
        rooms = data;
        webSocketChannel.sink.add(
            "tocloud//captors//where{#}room_id IN ${concatRoomsId()}//get");
      } else if (captors.isEmpty) {
        // Handle incoming message here
        Iterable l = json.decode(message);
        var data = List<Captor>.from(l.map((model) => Captor.fromJson(model)));
        captors = data;
        webSocketChannel.sink.add(
            "tocloud//users//join{#}user_building ON users.id = user_building.user_id{#}where{#}user_building.building_id IN ${concatBuildingsId()}{#}group{#}users.id//get");
      } else if (users.isEmpty) {
        Iterable l = json.decode(message);
        var data = List<User>.from(l.map((model) => User.fromJson(model)));
        users = data;
        webSocketChannel.sink.add(
            "tocloud//automations//where{#}automations.user_id IN ${concatUsersId()}//get");
      } else if (automations.isEmpty) {
        Iterable l = json.decode(message);
        var data =
            List<Automation>.from(l.map((model) => Automation.fromJson(model)));
        automations = data;
        webSocketChannel.sink.add(
            "tocloud//captor_values//where{#}captor_values.automation_id IN ${concatAutomationsId()}//get");
      } else if (automationValues.isEmpty) {
        Iterable l = json.decode(message);
        var data = List<AutomationValue>.from(
            l.map((model) => AutomationValue.fromJson(model)));
        automationValues = data;
      }
    } catch (e) {
      stderr.writeln(e);
    }
  });
}
