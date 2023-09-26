import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Falló la versión de la plataforma';
    }

    if (!mounted) return;
    setState(() {});
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
              DataTable(
                columns: const [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Codigo')),
                  DataColumn(label: Text('Dirección')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Juan')),
                    DataCell(Text('30')),
                    DataCell(Text('30')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('María')),
                    DataCell(Text('28')),
                    DataCell(Text('28')),
                  ]),
                ],
              ),
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
