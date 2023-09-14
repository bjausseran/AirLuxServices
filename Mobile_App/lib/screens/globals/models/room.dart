library airlux.globals.models.room;

class Room {
  Room({
    required this.id,
    required this.name,
    required this.buildingId,
  });

  int id;
  String name;
  int buildingId;

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        buildingId = json['building_id'],
        name = json['name'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'building_id': buildingId, 'name': name};
}
