class Direccion {
  int id;
  String? correlativo;
  int? idAgencia;
  int? idUbicacion;
  int? idCliente;
  int? idMotorizado;
  String? dniRuc;
  String? nombreContacto;
  String? celulares;
  String? direccion;
  String? departamento;
  String? provincia;
  String? distrito;
  String? referencia;
  String? observaciones;
  String? googleMaps;
  int? estado;
  int? recibido;

  Direccion({
    required this.id,
    required this.correlativo,
    this.idCliente,
    this.idAgencia,
    this.idUbicacion,
    this.idMotorizado,
    this.direccion,
    this.recibido,
    this.dniRuc,
    this.nombreContacto,
    this.celulares,
    this.departamento,
    this.provincia,
    this.distrito,
    this.referencia,
    this.observaciones,
    this.googleMaps,
    this.estado,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        correlativo: json["correlativo"],
        idCliente: json["id_cliente"],
        idAgencia: json["id_cliente"],
        idUbicacion: json["id_cliente"],
        idMotorizado: json["id_motorizado"],
        direccion: json["direccion"],
        recibido: json["recibido"],
        dniRuc: json['dni_ruc'],
        nombreContacto: json['nombre_contacto'],
        celulares: json['celulares'],
        departamento: json['departamento'],
        provincia: json['provincia'],
        distrito: json['distrito'],
        referencia: json['referencia'],
        observaciones: json['observaciones'],
        googleMaps: json['google_maps'],
        estado: json['estado'],
      );

  static List<Direccion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Direccion.fromJson(e)).toList();
}
