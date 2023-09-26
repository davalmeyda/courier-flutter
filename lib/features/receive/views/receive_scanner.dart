import 'package:flutter/material.dart';
import 'package:scanner_qr/features/receive/services/pedido_entity.dart';

class ReceiveScannerView extends StatefulWidget {
  const ReceiveScannerView({super.key});
  static const String route = 'ReceiveScannerView';
  @override
  State<ReceiveScannerView> createState() => _ReceiveScannerViewState();
}

class _ReceiveScannerViewState extends State<ReceiveScannerView> {
  List<Pedidos>? receiveListToConfirm = [];
  @override
  void initState() {
    super.initState();
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
                  // TODO: Confirmar recepcion
                  // Navigator.pushNamed(context, ReceiveListView.route);
                },
                label: const Text('Confirmar'),
                icon: const Icon(Icons.check),
              )
            : null,
        body: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.black,
              child: const Text('Scanner'),
            ),
            receiveListToConfirm!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 30),
                      shrinkWrap: true,
                      itemCount: receiveListToConfirm!.length,
                      itemBuilder: (context, index) {
                        final Pedidos receive = receiveListToConfirm![index];
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
                                        child: Text(receive.codigo),
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
