import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:scanner_qr/features/deliver/views/deliver_details.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:scanner_qr/shared/shared.dart';

class DeliverScannerView extends StatefulWidget {
  const DeliverScannerView({super.key});
  static const String route = 'DeliverScannerView';
  @override
  State<DeliverScannerView> createState() => _DeliverScannerViewState();
}

class _DeliverScannerViewState extends State<DeliverScannerView> {
  final codeValueController = TextEditingController();
  String? codeValue;
  bool isKeyboard = false;
  Direccion? adress;
  Cliente? client;
  Ubicacion? deliverLocation;
  Agencia? deliverAgency;
  String messageStatus = 'Escanee el código de barras';
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
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(map['message'] + ': $deliverCode'),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despachar'),
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
      body: Container(
        child: adress != null
            ? DeliverDetails(adress, client, deliverAgency, deliverLocation)
            : Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.black,
                    child: QrCamera(
                      onError: (context, error) => Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
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
      ),
    );
  }
}
