import 'package:scanner_qr/models/models.dart';

class Pedido {
  int id;
  String? correlativo;
  String? condicionEnvio;
  int? condicionEnvioCode;
  String? codigo;
  String? cRazonsocial;
  DateTime? createdAt;
  DateTime? updatedAt;
  DireccionDt direccionDt;

  Pedido({
    required this.id,
    this.correlativo,
    this.codigo,
    this.updatedAt,
    this.createdAt,
    this.condicionEnvio,
    this.condicionEnvioCode,
    this.cRazonsocial,
    required this.direccionDt,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id"],
        correlativo: json["correlativo"],
        condicionEnvio: json["condicion_envio"],
        condicionEnvioCode: json["condicion_envio_code"],
        codigo: json["codigo"],
        cRazonsocial: json["c_razonsocial"],
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
        direccionDt: DireccionDt.fromJson(json["direccionDt"]),
      );

  static List<Pedido> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Pedido.fromJson(e)).toList();
}
