import 'package:scanner_qr/models/models.dart';

class DireccionDt {
  int id;
  String codigo;
  String? producto;
  int? cantidad;
  Direccion direccion;

  DireccionDt({
    required this.id,
    required this.codigo,
    required this.direccion,
    this.producto,
    this.cantidad,
  });

  factory DireccionDt.fromJson(Map<String, dynamic> json) => DireccionDt(
        id: json["id"],
        codigo: json["codigo"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        direccion: Direccion.fromJson(json["direccion"]),
      );

  static List<DireccionDt> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => DireccionDt.fromJson(e)).toList();
}
