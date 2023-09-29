// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner_qr/shared/config/config.dart';
import 'package:scanner_qr/shared/utils/alert.dart';
import 'package:scanner_qr/shared/utils/compress_image.dart';

class DeliverRescheduleView extends StatefulWidget {
  const DeliverRescheduleView({
    super.key,
    required this.deliver,
  });
  static const String route = 'DeliverScannerView';
  final Direccion deliver;
  @override
  State<DeliverRescheduleView> createState() => _DeliverRescheduleViewState();
}

class _DeliverRescheduleViewState extends State<DeliverRescheduleView> {
  Direccion? deliver;
  String? reason;
  List<File>? deliverPhotos = [];

  @override
  void initState() {
    super.initState();
    deliver = widget.deliver;
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
          '${EnvironmentVariables.baseUrl}pedido/reprogramar/${deliver!.id}?idUser=${authBloc2.user['id']}&motivo=$reason'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['statusCode'] == 200) {
      final idReschedule = json.decode(response.body)['body']['id'];
      for (var element in deliverPhotos!) {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${EnvironmentVariables.baseUrl}pedido/imagenReprogramacion/${deliver!.id}?user_id=${authBloc2.user['id']}&reprogramacion_id=$idReschedule'),
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
                              child: Text(deliver!.correlativo ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: deliver!.direciones!.map(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFiles =
                                    await picker.pickMultiImage();
                                if (pickedFiles.isNotEmpty) {
                                  final List<File> compressedImages = [];
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Galería',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (pickedFile != null) {
                                  final List<File> compressedImages =
                                      deliverPhotos ?? [];
                                  var result = await compressImage(pickedFile);
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Cámara',
                                    style: TextStyle(color: Colors.white),
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
