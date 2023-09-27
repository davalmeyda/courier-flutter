import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scanner_qr/features/features.dart';

class ReceiveScannerView extends StatefulWidget {
  const ReceiveScannerView({super.key});
  static const String route = 'ReceiveScannerView';
  @override
  State<ReceiveScannerView> createState() => _ReceiveScannerViewState();
}

class _ReceiveScannerViewState extends State<ReceiveScannerView> {
  List<String>? receiveListToConfirm = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> changeStatusManyReceives(context) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse('http://192.168.1.73:3000/pedido/recibir'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, List<String>>{'codigos': receiveListToConfirm!}),
    );
    final map = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(map.toString());

    if (map['statusCode'] == 200) {
      setState(() {
        receiveListToConfirm!.clear();
      });
      Navigator.pushReplacementNamed(context, ReceiveListView.route);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recibir pedidos'),
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
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.black,
              child: QrCamera(
                cameraDirection: CameraDirection.FRONT,
                qrCodeCallback: (code) async {
                  if (code!.isNotEmpty) {
                    if (receiveListToConfirm!.isNotEmpty &&
                        receiveListToConfirm!
                            .any((element) => code == element)) {
                      return;
                    }
                    setState(() {
                      receiveListToConfirm!.add(code);
                    });
                  }
                  final player = AudioPlayer();
                  await player.setSource(AssetSource('audio/scanner.mp3'));
                  await player.resume();
                  await player.stop();
                  Timer(const Duration(seconds: 3), () {
                    debugPrint('timer');
                  });
                },
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
