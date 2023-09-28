import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner_qr/shared/config/config.dart';

class DeliverRescheduleView extends StatefulWidget {
  const DeliverRescheduleView({
    super.key,
    required this.deliver,
  });
  static const String route = 'DeliverScannerView';
  final Pedido deliver;
  @override
  State<DeliverRescheduleView> createState() =>
      _DeliverRescheduleViewState(deliver: deliver);
}

class _DeliverRescheduleViewState extends State<DeliverRescheduleView> {
  final Pedido deliver;
  String? reason;
  List<File>? deliverPhotos = [];

  _DeliverRescheduleViewState({required this.deliver});

  @override
  void initState() {
    super.initState();
  }

  Future<void> confirmReschedule(BuildContext context) async {
    if (deliverPhotos!.isEmpty) {
      return;
    }
    if (reason == null || reason!.length < 5) {
      return;
    }
    final response = await http.put(
      Uri.parse(
          '${EnvironmentVariables.baseUrl}pedido/reprogramar/${deliver?.codigo}?idUser=${authBloc2.user['id']}&motivo=$reason'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final idReschedule = json.decode(response.body)['body']['id'];
      for (var element in deliverPhotos!) {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${EnvironmentVariables.baseUrl}pedido/imagenReprogramacion/${deliver?.codigo}?user_id=${authBloc2.user['id']}&reprogramacion_id=$idReschedule'),
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
      Navigator.popAndPushNamed(context, HomeView.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reprogramar'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            const Text('Pedido:'),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(deliver!.correlativo ?? ''),
                            ),
                          ],
                        ),
                        deliver!.direccionDt.direccion.correlativo != null
                            ? const SizedBox(height: 10)
                            : const SizedBox(),
                        deliver!.direccionDt.direccion.correlativo != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dirección:'),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(deliver!.direccionDt.direccion
                                            .correlativo ??
                                        ''),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 20),
                        TextFormField(
                          maxLines: 5,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            hintText: 'Ingresa el motivo',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) => {
                            setState(() {
                              reason = value;
                            })
                          },
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFiles = await picker.pickMultiImage();
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
                            backgroundColor: Colors.blue,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Agregar fotos',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
                              backgroundColor: Colors.green,
                            ),
                            onPressed: deliverPhotos!.isEmpty ||
                                    (reason == null ? true : reason!.length < 5)
                                ? null
                                : () => confirmReschedule(context),
                            child: const Text(
                              'Reprogramar',
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
        ));
  }
}
