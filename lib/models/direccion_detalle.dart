import 'package:scanner_qr/models/models.dart';

class DireccionDt {
  int id;
  String? codigo;
  String? producto;
  int? cantidad;
  int? recibido;
  int? entregado;
  int? confirmado;
  Direccion? direccion;
  Pedido? pedido;

  DireccionDt({
    required this.id,
    this.codigo,
    this.producto,
    this.cantidad,
    this.recibido,
    this.entregado,
    this.confirmado,
    this.direccion,
    this.pedido,
  });

  factory DireccionDt.fromJson(Map<String, dynamic> json) => DireccionDt(
        id: json["id"],
        codigo: json["codigo"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        recibido: json["recibido"],
        entregado: json["entregado"],
        confirmado: json["confirmado"],
        direccion: json["direccion"] != null
            ? Direccion.fromJson(json["direccion"])
            : null,
        pedido: Pedido.fromJson(json["pedido"]),
      );

  static List<DireccionDt> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => DireccionDt.fromJson(e)).toList();
}
