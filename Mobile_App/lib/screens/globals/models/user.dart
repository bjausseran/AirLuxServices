library airlux.globals.models.user;

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.authorized,
  });

  int id;
  String name;
  String email;
  late bool authorized;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'] {
    authorized = json['authorized'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'email': email, 'name': name, 'authorized': authorized};
}
