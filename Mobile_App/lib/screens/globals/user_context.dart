library airlux.globals.user_context;

import 'package:airlux/screens/globals/models/building.dart';
import 'package:airlux/screens/globals/models/room.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models/captor.dart';

final WebSocketChannel webSocketChannel =
    WebSocketChannel.connect(Uri.parse('ws://$serverIP:6001'));

int userId = -1;
//String serverIP = "localhost";
String serverIP = "192.168.196.72";

List<Building> buildings = List.empty(growable: true);
List<Room> rooms = List.empty(growable: true);
List<Captor> captors = List.empty(growable: true);
