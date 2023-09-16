library airlux.globals.models.building;

class Building {
  Building({
    required this.id,
    required this.name,
    required this.type,
  });

  int id;
  String name;
  String type;

  Building.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = json['type'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'id': id,
      };
}
