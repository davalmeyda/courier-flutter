class Reprogramacion {
  int id;
  String? motivo;
  int? userId;

  Reprogramacion({
    required this.id,
    this.motivo,
    this.userId,
  });

  factory Reprogramacion.fromJson(Map<String, dynamic> json) => Reprogramacion(
        id: json["id"],
        motivo: json["motivo"],
        userId: json["user_id"],
      );

  static List<Reprogramacion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Reprogramacion.fromJson(e)).toList();
}
