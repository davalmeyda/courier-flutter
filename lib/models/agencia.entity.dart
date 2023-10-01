class Agencia {
  int id;
  String? codAgencia;
  String? nombreAgencia;

  Agencia({
    required this.id,
    this.codAgencia,
    this.nombreAgencia,
  });

  factory Agencia.fromJson(Map<String, dynamic> json) => Agencia(
        id: json["id"],
        codAgencia: json["cod_agencia"],
        nombreAgencia: json["nombre_agencia"],
      );

  static List<Agencia> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Agencia.fromJson(e)).toList();
}
