import 'package:scanner_qr/models/models.dart';

class Direccion {
  int id;
  String? correlativo;
  int? idAgencia;
  int? idCliente;
  int? idUbicacion;
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
  String? importe;
  int? recibido;
  int? entregado;
  int? confirmado;
  String? estadoDir;
  int? estadoDirCode;
  List<DireccionDt>? direciones;
  List<Reprogramacion>? reprogramaciones;

  Direccion({
    required this.id,
    this.correlativo,
    this.idAgencia,
    this.idCliente,
    this.idUbicacion,
    this.idMotorizado,
    this.dniRuc,
    this.nombreContacto,
    this.celulares,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
    this.referencia,
    this.observaciones,
    this.googleMaps,
    this.estado,
    this.importe,
    this.recibido,
    this.entregado,
    this.confirmado,
    this.estadoDir,
    this.estadoDirCode,
    this.direciones,
    this.reprogramaciones,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        correlativo: json["correlativo"],
        idCliente: json["id_cliente"],
        idAgencia: json["id_agencia"],
        idUbicacion: json["id_ubicacion"],
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
        importe: json['importe'],
        entregado: json['entregado'],
        confirmado: json['confirmado'],
        estadoDir: json['estado_dir'],
        estadoDirCode: json['estado_dir_code'],
        direciones: DireccionDt.fromJsonList(json['direciones']),
        reprogramaciones: Reprogramacion.fromJsonList(json['reprogramaciones']),
      );

  static List<Direccion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Direccion.fromJson(e)).toList();
}
