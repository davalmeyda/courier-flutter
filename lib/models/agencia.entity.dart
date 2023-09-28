class Agencia {
  int id;
  String? codAgencia;
  String? nombreAgencia;
  DateTime? createdAt;
  DateTime? updatedAt;

  Agencia({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.codAgencia,
    this.nombreAgencia,
  });

  factory Agencia.fromJson(Map<String, dynamic> json) => Agencia(
        id: json["id"],
        codAgencia: json["cod_agencia"],
        nombreAgencia: json["nombre_agencia"],
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
      );

  static List<Agencia> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Agencia.fromJson(e)).toList();
}
