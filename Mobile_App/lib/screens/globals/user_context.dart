library airlux.globals.user_context;

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';

import 'models/captor.dart';

int userId = -1;
//String serverIP = "localhost";
String serverIP = "192.168.43.148";

List<Building> buildings = List.empty(growable: true);
List<Room> rooms = List.empty(growable: true);
List<Captor> captors = List.empty(growable: true);
