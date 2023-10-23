import 'package:ojo_courier/models/models.dart';

class Direccion {
  int id;
  String? correlativo;
  int? idAgencia;
  int? idCliente;
  int? idUbicacion;
  int? idMotorizado;
  String? dniRuc;
  String? agencia;
  String? ubicacion;
  String? nombreContacto;
  String? celulares;
  String? direccion;
  String? departamento;
  String? provincia;
  String? distrito;
  String? referencia;
  String? observaciones;
  String? googleMaps;
  String? empresaTransporte;
  String? fecha_asig_motorizado;
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
    this.agencia,
    this.idCliente,
    this.idUbicacion,
    this.ubicacion,
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
    this.empresaTransporte,
    this.estado,
    this.importe,
    this.recibido,
    this.entregado,
    this.confirmado,
    this.estadoDir,
    this.estadoDirCode,
    this.direciones,
    this.reprogramaciones,
    this.fecha_asig_motorizado,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        correlativo: json["correlativo"],
        idCliente: json["id_cliente"],
        idAgencia: json["id_agencia"],
        agencia: json["agencia"],
        idUbicacion: json["id_ubicacion"],
        ubicacion: json["ubicacion"],
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
        empresaTransporte: json['empresa_transporte'],
        estado: json['estado'],
        importe: json['importe'],
        entregado: json['entregado'],
        confirmado: json['confirmado'],
        estadoDir: json['estado_dir'],
        estadoDirCode: json['estado_dir_code'],
        direciones: DireccionDt.fromJsonList(json['direciones']),        
        reprogramaciones: Reprogramacion.fromJsonList(json['reprogramaciones']),
        fecha_asig_motorizado: json['fecha_asig_motorizado'],
      );

  static List<Direccion> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => Direccion.fromJson(e)).toList();
}
