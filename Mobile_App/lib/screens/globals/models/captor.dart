library airlux.globals.models.captor;

enum CaptorType { temp, light, door, shutter, move }

class Captor {
  Captor({
    required this.id,
    required this.name,
    required this.roomId,
    required this.type,
    required this.value,
  });

  String id;
  String name;
  String roomId;
  int value;
  CaptorType type;

  Captor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        roomId = json['room_id'],
        name = json['name'],
        value = json['value'],
        type = CaptorType.light {
    switch (json['type']) {
      case "temp":
        type = CaptorType.temp;
        break;
      case "light":
        type = CaptorType.light;
        break;
      case "door":
        type = CaptorType.door;
        break;
      case "shutter":
        type = CaptorType.shutter;
        break;
      case "move":
        type = CaptorType.move;
        break;
      default:
        type = CaptorType.light;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'name': name,
        'value': value,
        'type': type.toString()
      };
}
