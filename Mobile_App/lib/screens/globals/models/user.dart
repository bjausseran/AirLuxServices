library airlux.globals.models.user;

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  int id;
  String name;
  String email;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}
