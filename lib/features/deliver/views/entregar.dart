import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Entregar extends StatefulWidget {
  const Entregar({super.key});

  @override
  State<Entregar> createState() => _EntregarState();
}

class _EntregarState extends State<Entregar> {
  String barcodeScanRes = '';

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

      //--- SI EL USUARIO NO CANCELA EL SCANER
      // if (barcodeScanRes != '-1') {
      getScanearQR(barcodeScanRes);
      //   }
    } on PlatformException {
      // debugPrint('Falló la versión de la plataforma');
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> getScanearQR(String codigo) async {
    final response = await http.get(
        Uri.parse('http://192.168.1.107:3000/pedido/$codigo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    debugPrint(response.body);

    // final datosObtenidos = response.body;

    // Navega a la pantalla de mostrar datos y pasa los datos como argumento
    // ignore: use_build_context_synchronously
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PantallaMostrarDatos(datos: datosObtenidos),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Segunda Vista'),
      ),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(barcodeScanRes),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: scanBarcodeNormal,
                child: const Text('Escanear codigo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
