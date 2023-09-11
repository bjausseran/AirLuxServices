library airlux.globals.models.building;

class Building {
  Building({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  Building.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        id = json['id'].toString();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
