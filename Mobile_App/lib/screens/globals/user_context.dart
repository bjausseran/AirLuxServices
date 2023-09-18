library airlux.globals.user_context;

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:airlux/screens/globals/models/user.dart';
import 'models/captor.dart';

int userId = -1;
String serverIP = "localhost";
//String serverIP = "192.168.196.72";

List<Building> buildings = List.empty(growable: true);
List<Room> rooms = List.empty(growable: true);
List<Captor> captors = List.empty(growable: true);
List<User> users = List.empty(growable: true);

String concatBuildingsId() {
  var str = "(";
  for (int i = 0; i < buildings.length; i++) {
    str += buildings[i].id.toString();
    if (i != buildings.length - 1) str += ",";
  }
  str += ")";
  return str;
}
