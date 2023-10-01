class Ubicacion {
  int id;
  String? codUbicacion;
  String? nombreUbicacion;

  Ubicacion({
    required this.id,
    this.codUbicacion,
    this.nombreUbicacion,
  });

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
        id: json["id"],
        codUbicacion: json["cod_ubicacion"],
        nombreUbicacion: json["nombre_ubicacion"],
      );

  static List<Ubicacion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Ubicacion.fromJson(e)).toList();
}
