class Reprogramacion {
  int id;
  String? motivo;
  int? userId;
  DateTime? createdAt;
  DateTime? fechaReprog;
  DateTime? updatedAt;

  Reprogramacion({
    required this.id,
    this.motivo,
    this.userId,
    this.createdAt,
    this.fechaReprog,
    this.updatedAt,
  });

  factory Reprogramacion.fromJson(Map<String, dynamic> json) => Reprogramacion(
        id: json["id"],
        motivo: json["motivo"],
        userId: json["user_id"],
        fechaReprog: json["fecha_reprog"] != null
            ? DateTime.parse(json["fecha_reprog"])
            : DateTime.now(),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  static List<Reprogramacion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Reprogramacion.fromJson(e)).toList();
}
