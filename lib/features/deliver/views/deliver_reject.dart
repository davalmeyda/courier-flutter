import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:ojo_courier/models/models.dart';
import 'package:ojo_courier/shared/shared.dart';
import 'package:ojo_courier/features/features.dart';

import 'package:ojo_courier/features/auth/bloc/auth_bloc2.dart';

class DeliverRejectView extends StatefulWidget {
  const DeliverRejectView({
    super.key,
    required this.deliver,
  });
  static const String route = 'DeliverRejectView';
  final Direccion deliver;
  @override
  State<DeliverRejectView> createState() => _DeliverRejectViewState();
}

class _DeliverRejectViewState extends State<DeliverRejectView> {
  Direccion? deliver;
  String? reason;
  List<File>? deliverPhotos = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    deliver = widget.deliver;
  }

  Future<void> confirmReschedule(BuildContext context) async {
    setState(() {
      loading = true;
    });
    if (deliverPhotos!.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }
    if (reason == null || reason!.length < 5) {
      setState(() {
        loading = false;
      });
      return;
    }

    final response = await http.put(
      Uri.parse(
          '${EnvironmentVariables.baseUrl}pedido/rechazar/${deliver!.id}?idUser=${authBloc2.user!.id}&motivo=$reason'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['statusCode'] == 200) {
      final idRejected = json.decode(response.body)['body']['id'];
      for (var element in deliverPhotos!) {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${EnvironmentVariables.baseUrl}pedido/imagenRechazar/${deliver!.id}?user_id=${authBloc2.user!.id}&rechazado_id=$idRejected'),
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
      setState(() {
        loading = false;
      });
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        loading = false;
      });
      if (!context.mounted) return;
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
          title: const Text('No entregado'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: CardWidget(
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
                          final pickedFiles = await picker.pickMultiImage();
                          if (pickedFiles.isNotEmpty) {
                            final List<File> compressedImages = [];
                            for (var pickedFile in pickedFiles) {
                              var result = await compressImage(pickedFile);
                              compressedImages.add(result);
                            }
                            setState(() {
                              deliverPhotos = compressedImages;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primary,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, color: Colors.white),
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
                          backgroundColor: CustomColors.primary,
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
                        backgroundColor: Colors.red,
                      ),
                      onPressed: loading
                          ? null
                          : deliverPhotos!.isEmpty ||
                                  (reason == null ? true : reason!.length < 5)
                              ? null
                              : () => confirmReschedule(context),
                      child: const Text(
                        'No entregado',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
