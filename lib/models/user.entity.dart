class User {
  int? id;
  String? name;
  String? email;
  String? rol;

  User({
    this.id,
    this.name,
    this.email,
    this.rol,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    rol = json['rol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['rol'] = rol;
    return data;
  }
}
