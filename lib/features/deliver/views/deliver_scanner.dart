import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:image_picker/image_picker.dart';

class DeliverScannerView extends StatefulWidget {
  const DeliverScannerView({super.key});
  static const String route = 'DeliverScannerView';
  @override
  State<DeliverScannerView> createState() => _DeliverScannerViewState();
}

class _DeliverScannerViewState extends State<DeliverScannerView> {
  Pedido? deliver;
  Cliente? client;
  Ubicacion? deliverLocation;
  Agencia? deliverAgency;
  String messageStatus = 'Escanee el código de barras';
  int? amount = 0;
  List<File>? deliverPhotos;
  bool? loading;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getDeliverDetails(String? deliverCode) async {
    setState(() {
      messageStatus = 'Buscando...';
    });
    final response = await http.get(
      Uri.parse('http://192.168.1.73:3000/pedido/$deliverCode'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final map = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(map.toString());

    if (map['statusCode'] == 200) {
      if (map['body']['pedido'] == null) {
        setState(() {
          messageStatus = 'No se encontró el pedido';
        });
        return;
      }
      if (map['body']['cliente'] != null) {
        setState(() {
          client = Cliente.fromJson(map['body']['cliente']);
        });
      }
      if (map['body']['ubicacion'] != null) {
        setState(() {
          deliverLocation = Ubicacion.fromJson(map['body']['ubicacion']);
        });
      }
      if (map['body']['agencia'] != null) {
        setState(() {
          deliverAgency = Agencia.fromJson(map['body']['agencia']);
        });
      }
      setState(() {
        deliver = Pedido.fromJson(map['body']['pedido']);
        messageStatus = 'Escanee el código de barras';
      });
    } else {
      setState(() {
        messageStatus = map['message'];
      });
    }
  }

  Future<void> confirmDelivery() async {
    setState(() {
      loading = true;
    });
    debugPrint(deliver?.codigo);
    debugPrint(amount.toString());
    if (deliverPhotos == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    for (var element in deliverPhotos!) {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'http://192.168.1.73:3000/pedido/imagenDespacho/${deliver?.codigo}?user_id=${authBloc2.user['id']}&importe=$amount'),
      );
      // TODO: Cambiar la lógica de imágenes
      request.files.add(
        http.MultipartFile(
          'imagen',
          element.readAsBytes().asStream(),
          element.lengthSync(),
          filename: element.path.split('/').last,
        ),
      );
      await request.send();
    }
    final response = await http.put(
      Uri.parse(
          'http://192.168.1.73:3000/pedido/entregar/${deliver?.codigo}?idUser=${authBloc2.user['id']}&importe=$amount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      Navigator.popAndPushNamed(context, HomeView.route);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Despachar'),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: receiveListToConfirm!.isNotEmpty
        //     ? FloatingActionButton.extended(
        //         onPressed: () {
        //           changeStatusManyReceives(context);
        //         },
        //         label: const Text('Confirmar'),
        //         icon: const Icon(Icons.check),
        //       )
        //     : null,
        body: Container(
          child: deliver != null
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Código:'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(deliver!.codigo ?? ''),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Correlativo de pedido:'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(deliver!.correlativo ?? ''),
                                    ),
                                  ],
                                ),
                                deliver!.direccionDt.direccion.correlativo !=
                                        null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.correlativo !=
                                        null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                              'Correlativo de dirección:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.correlativo ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.direccion != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.direccion != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Dirección:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.direccion ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.departamento !=
                                        null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.departamento !=
                                        null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Departamento:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.departamento ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.provincia != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.provincia != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Provincia:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.provincia ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.distrito != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.distrito != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Distrito:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.distrito ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.referencia !=
                                        null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.referencia !=
                                        null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Referencia:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.referencia ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.observaciones !=
                                        null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.direccionDt.direccion.observaciones !=
                                        null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Observaciones:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliver!.direccionDt
                                                    .direccion.observaciones ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.condicionEnvio != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.condicionEnvio != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Condicion de envío:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                '${deliver!.condicionEnvioCode != null ? '${deliver!.condicionEnvioCode} / ' : ''}${deliver!.condicionEnvio ?? ''}'),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliver!.cRazonsocial != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliver!.cRazonsocial != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Razón Social:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                deliver!.cRazonsocial ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                client?.nombre != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                client?.nombre != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Cliente:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                '${client?.dni != null ? '${client?.dni} / ' : ''}${client?.nombre ?? ''}'),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                client?.dni != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                client?.dni != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('DNI Cliente:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(client?.dni ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                client?.celular != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                client?.celular != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Celular del Cliente:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                client?.celular.toString() ??
                                                    ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliverAgency?.nombreAgencia != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliverAgency?.nombreAgencia != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Agencia:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                deliverAgency?.nombreAgencia ??
                                                    ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                deliverLocation?.nombreUbicacion != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                deliverLocation?.nombreUbicacion != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Destino:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(deliverLocation
                                                    ?.nombreUbicacion ??
                                                ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 50),
                                deliverAgency?.id == 3
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: 'Importe',
                                              border: OutlineInputBorder(),
                                              prefixIcon: Icon(Icons
                                                  .monetization_on_outlined),
                                              fillColor: Colors.white),
                                          onChanged: (value) => {
                                            setState(() {
                                              amount = int.parse(value);
                                            })
                                          },
                                          keyboardType: TextInputType.number,
                                        ),
                                      )
                                    : const SizedBox(),
                                deliverAgency?.id == 3
                                    ? const SizedBox(height: 20)
                                    : const SizedBox(),
                                ElevatedButton(
                                  onPressed: () async {
                                    final picker = ImagePicker();
                                    final pickedFiles =
                                        await picker.pickMultiImage();
                                    if (pickedFiles.isNotEmpty) {
                                      setState(() {
                                        deliverPhotos = pickedFiles
                                            .map((e) => File.fromUri(
                                                  Uri(path: e.path),
                                                ))
                                            .toList();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: deliverPhotos != null
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        'Foto de entrega',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          debugPrint(deliver?.codigo);
                                        },
                                        child: const Text(
                                          'Rechazar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => confirmDelivery(),
                                        child: const Text('Confirmar'),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: 550,
                      width: double.infinity,
                      color: Colors.black,
                      child: QrCamera(
                        cameraDirection: CameraDirection.FRONT,
                        qrCodeCallback: (code) async {
                          if (code!.isNotEmpty) {
                            getDeliverDetails(code);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          messageStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
