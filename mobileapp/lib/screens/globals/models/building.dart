library airlux.globals.models.building;

class Building {
  Building({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  Building.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
