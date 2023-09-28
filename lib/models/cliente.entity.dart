class Cliente {
  int id;
  String? correlativo;
  String? nombre;
  String? dni;
  int? celular;
  DateTime? createdAt;
  DateTime? updatedAt;

  Cliente({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.correlativo,
    this.nombre,
    this.dni,
    this.celular,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        correlativo: json["correlativo"],
        nombre: json["nombre"],
        dni: json["dni"],
        celular: json["celular"],
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
      );

  static List<Cliente> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Cliente.fromJson(e)).toList();
}
