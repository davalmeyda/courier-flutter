class Cliente {
  int id;
  String? correlativo;
  String? nombre;
  String? dni;
  int? celular;

  Cliente({
    required this.id,
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
      );

  static List<Cliente> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Cliente.fromJson(e)).toList();
}
