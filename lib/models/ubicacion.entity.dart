class Ubicacion {
  int id;
  String? codUbicacion;
  String? nombreUbicacion;
  DateTime? createdAt;
  DateTime? updatedAt;

  Ubicacion({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.codUbicacion,
    this.nombreUbicacion,
  });

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
        id: json["id"],
        codUbicacion: json["cod_ubicacion"],
        nombreUbicacion: json["nombre_ubicacion"],
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
      );

  static List<Ubicacion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Ubicacion.fromJson(e)).toList();
}
