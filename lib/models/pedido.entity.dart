import 'package:ojo_courier/models/direccion_detalle.dart';

class Pedido {
  int id;
  String? correlativo;
  String? condicionEnvio;
  int? condicionEnvioCode;
  String? codigo;
  String? cRazonsocial;
  DireccionDt? direccionDt;

  Pedido({
    required this.id,
    this.correlativo,
    this.condicionEnvio,
    this.condicionEnvioCode,
    this.codigo,
    this.cRazonsocial,
    this.direccionDt,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id"],
        correlativo: json["correlativo"],
        condicionEnvio: json["condicion_envio"],
        condicionEnvioCode: json["condicion_envio_code"],
        codigo: json["codigo"],
        cRazonsocial: json["c_razonsocial"],
        direccionDt: json["direccionDt"] != null
            ? DireccionDt.fromJson(json["direccionDt"])
            : null,
      );

  static List<Pedido> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Pedido.fromJson(e)).toList();
}
