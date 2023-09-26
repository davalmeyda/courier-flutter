class Pedidos {
  int id;
  String correlativo;
  String condicionEnvio;
  int condicionEnvioCode;
  String codigo;
  String cRazonsocial;
  DateTime createdAt;
  DateTime updatedAt;
  DireccionDt direccionDt;

  Pedidos({
    required this.id,
    required this.correlativo,
    required this.condicionEnvio,
    required this.condicionEnvioCode,
    required this.codigo,
    required this.cRazonsocial,
    required this.createdAt,
    required this.updatedAt,
    required this.direccionDt,
  });

  factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
        id: json["id"],
        correlativo: json["correlativo"],
        condicionEnvio: json["condicion_envio"],
        condicionEnvioCode: json["condicion_envio_code"],
        codigo: json["codigo"],
        cRazonsocial: json["c_razonsocial"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        direccionDt: DireccionDt.fromJson(json["direccionDt"]),
      );

  static List<Pedidos> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Pedidos.fromJson(e)).toList();
}

class DireccionDt {
  int id;
  String codigo;
  String producto;
  int cantidad;
  Direccion direccion;

  DireccionDt({
    required this.id,
    required this.codigo,
    required this.producto,
    required this.cantidad,
    required this.direccion,
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

class Direccion {
  int id;
  String correlativo;
  String direccion;
  int idCliente;
  String recibido;

  Direccion({
    required this.id,
    required this.correlativo,
    required this.direccion,
    required this.idCliente,
    required this.recibido,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        correlativo: json["correlativo"],
        direccion: json["direccion"],
        idCliente: json["id_cliente"],
        recibido: json["recibido"],
      );

  static List<Direccion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Direccion.fromJson(e)).toList();
}
