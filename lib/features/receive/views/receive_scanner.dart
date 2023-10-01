import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/shared/config/config.dart';
import 'package:scanner_qr/shared/utils/alert.dart';
import 'package:flutter_beep/flutter_beep.dart';

class ReceiveScannerView extends StatefulWidget {
  const ReceiveScannerView({super.key});
  static const String route = 'ReceiveScannerView';
  @override
  State<ReceiveScannerView> createState() => _ReceiveScannerViewState();
}

class _ReceiveScannerViewState extends State<ReceiveScannerView> {
  final codeValueController = TextEditingController();
  List<String>? receiveListToConfirm = [];
  String? errorMessage;
  String? codeValue;
  bool isKeyboard = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> changeStatusManyReceives(BuildContext context) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse('${EnvironmentVariables.baseUrl}pedido/recibir'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'codigos': receiveListToConfirm!,
        'idUser': authBloc2.user.id,
      }),
    );
    final map = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(map.toString());

    if (map['statusCode'] == 200) {
      setState(() {
        receiveListToConfirm!.clear();
      });
      QrCameraState().stop();
      if (!context.mounted) return;
      Navigator.popAndPushNamed(context, HomeView.route);
    } else {
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

    setState(() {
      loading = false;
    });
  }

  dynamic currentBackPressTime;

  // FUNCION QUE AGREGA A LA LISTA
  void agregarLista(String? code) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 3)) {
      final response = await http.get(
        Uri.parse(
            '${EnvironmentVariables.baseUrl}pedido/consultaCodigo/$code?idUser=${authBloc2.user.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final map = json.decode(response.body) as Map<String, dynamic>;
      FlutterBeep.beep();

      currentBackPressTime = now;
      if (map['statusCode'] == 200) {
        if (code!.isNotEmpty) {
          if (receiveListToConfirm!.isNotEmpty &&
              receiveListToConfirm!.any((element) => code == element)) {
            return;
          }
          setState(() {
            receiveListToConfirm!.add(code);
          });
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(map['message']),
            duration: const Duration(milliseconds: 1000),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recibir'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onPressed: () {
                  setState(() {
                    isKeyboard = !isKeyboard;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                color: Colors.white,
                icon: Icon(isKeyboard ? Icons.camera_alt : Icons.keyboard),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: receiveListToConfirm!.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  changeStatusManyReceives(context);
                },
                label: const Text('Confirmar'),
                icon: const Icon(Icons.check),
              )
            : null,
        body: Column(
          children: [
            isKeyboard
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          autofocus: true,
                          controller: codeValueController,
                          decoration: const InputDecoration(
                            hintText: 'Ingrese el código',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => setState(() {
                            codeValue = value;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed:
                                codeValue != null && codeValue!.length < 2
                                    ? null
                                    : () {
                                        setState(() {
                                          receiveListToConfirm!.add(codeValue!);
                                        });
                                        codeValueController.clear();
                                      },
                            child: const Text(
                              'Agregar código',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  )
                : Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.black,
                    child: QrCamera(
                      onError: (context, error) => Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                      cameraDirection: CameraDirection.BACK,
                      qrCodeCallback: agregarLista,
                    ),
                  ),
            receiveListToConfirm!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 30),
                      shrinkWrap: true,
                      itemCount: receiveListToConfirm!.length,
                      itemBuilder: (context, index) {
                        final String receive = receiveListToConfirm![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(receive),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              MaterialButton(
                                height: 50,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                disabledColor: Colors.grey,
                                elevation: 0,
                                color: Colors.red,
                                child: const Center(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    receiveListToConfirm!.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : isKeyboard
                    ? const SizedBox()
                    : Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'Escanee un código de barras',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
          ],
        ));
  }
}
