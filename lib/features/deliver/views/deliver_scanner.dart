// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:image_picker/image_picker.dart';

import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:scanner_qr/shared/shared.dart';

import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';

class DeliverScannerView extends StatefulWidget {
  const DeliverScannerView({super.key});
  static const String route = 'DeliverScannerView';
  @override
  State<DeliverScannerView> createState() => _DeliverScannerViewState();
}

class _DeliverScannerViewState extends State<DeliverScannerView> {
  Direccion? adress;
  Cliente? client;
  Ubicacion? deliverLocation;
  Agencia? deliverAgency;
  String messageStatus = 'Escanee el código de barras';
  int? amount = 0;
  List<File>? deliverPhotos = [];
  bool? loading;
  dynamic currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getDeliverDetails(String? deliverCode) async {
    setState(() {
      messageStatus = 'Buscando...';
    });
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 3)) {
      final response = await http.get(
        Uri.parse('${EnvironmentVariables.baseUrl}pedido/$deliverCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final map = json.decode(response.body) as Map<String, dynamic>;
      FlutterBeep.beep();
      currentBackPressTime = now;

      if (map['statusCode'] == 200) {
        if (map['body']['direccion'] == null) {
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
          adress = Direccion.fromJson(map['body']['direccion']);
          messageStatus = 'Escanee el código de barras';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(map['message']),
            duration: const Duration(milliseconds: 1000),
          ),
        );
      }
    }
  }

  Future<void> confirmDelivery() async {
    setState(() {
      loading = true;
    });
    if (deliverPhotos == null || deliverPhotos!.isEmpty) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe adjuntar una imagen'),
          duration: Duration(milliseconds: 1000),
        ),
      );
      return;
    }
    List<DireccionDt> orders =
        adress?.direciones != null ? adress!.direciones! : [];
    for (var order in orders) {
      if (order.recibido == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No ha sido recibido'),
            duration: Duration(milliseconds: 1000),
          ),
        );
        return;
      }
      for (var element in deliverPhotos!) {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${EnvironmentVariables.baseUrl}pedido/imagenDespacho/${order.pedido?.codigo}?user_id=${authBloc2.user['id']}&importe=$amount'),
        );
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
            '${EnvironmentVariables.baseUrl}pedido/entregar/${order.pedido?.codigo}?idUser=${authBloc2.user['id']}&importe=$amount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final map = json.decode(response.body) as Map<String, dynamic>;

      if (map['statusCode'] == 200) {
        Navigator.popAndPushNamed(context, HomeView.route);
      } else {
        showDialog(
          context: context,
          builder: (context) => showSimpleDialog(
            'Error',
            map['message'],
            context,
          ),
        );
      }
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
        body: Container(
          child: adress != null
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
                                    const Text('Correlativo:'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(adress!.correlativo ?? ''),
                                    ),
                                  ],
                                ),
                                adress!.direccion != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.direccion != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Dirección:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child:
                                                Text(adress!.direccion ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.departamento != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.departamento != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Departamento:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                adress!.departamento ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.provincia != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.provincia != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Provincia:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child:
                                                Text(adress!.provincia ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.distrito != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.distrito != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Distrito:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(adress!.distrito ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.referencia != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.referencia != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Referencia:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child:
                                                Text(adress!.referencia ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.observaciones != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.observaciones != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Observaciones:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                adress!.observaciones ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.dniRuc != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.dniRuc != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Documento:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(adress!.dniRuc ?? ''),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                adress!.nombreContacto != null
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                adress!.nombreContacto != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Contacto:'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                adress!.nombreContacto ?? ''),
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
                                const SizedBox(height: 10),
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
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pedidos:'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: adress!.direciones!.map(
                                          (DireccionDt orderDetail) {
                                            if (orderDetail.recibido != 0) {
                                              return Row(
                                                children: [
                                                  Text(
                                                    orderDetail.codigo ?? '',
                                                  ),
                                                ],
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final pickedFiles =
                                            await picker.pickMultiImage();
                                        if (pickedFiles.isNotEmpty) {
                                          final List<File> compressedImages =
                                              [];
                                          for (var pickedFile in pickedFiles) {
                                            var result =
                                                await compressImage(pickedFile);
                                            compressedImages.add(result);
                                          }
                                          setState(() {
                                            deliverPhotos = compressedImages;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_library,
                                              color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            'Galería',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final pickedFile =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          final List<File> compressedImages =
                                              deliverPhotos ?? [];
                                          var result =
                                              await compressImage(pickedFile);
                                          compressedImages.add(result);
                                          setState(() {
                                            deliverPhotos = compressedImages;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_camera,
                                              color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            'Cámara',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ListView.builder(
                                  itemCount: deliverPhotos!.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Image.file(
                                              deliverPhotos![index],
                                              // width: 80,
                                              height: 80,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                deliverPhotos!.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return DeliverRejectView(
                                            deliver: adress!,
                                          );
                                        },
                                      ));
                                    },
                                    child: const Text(
                                      'No entregado',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeliverRejectView(
                                              deliver: adress!,
                                            ),
                                          ));
                                    },
                                    child: const Text(
                                      'Reprogramar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: deliverPhotos!.isEmpty
                                        ? null
                                        : () => confirmDelivery(),
                                    child: const Text(
                                      'Entregado',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
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
                        cameraDirection: CameraDirection.BACK,
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
