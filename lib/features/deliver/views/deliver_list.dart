import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'dart:convert';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:scanner_qr/shared/config/config.dart';

class DeliverListView extends StatefulWidget {
  const DeliverListView({super.key});
  static const String route = 'DeliverListView';
  @override
  State<DeliverListView> createState() => _DeliverListViewState();
}

class _DeliverListViewState extends State<DeliverListView> {
  bool loading = false;
  List<Direccion>? receiveList = [];

  @override
  void initState() {
    super.initState();
    getAllPendingReceives('', authBloc2.user['id'].toString());
  }

  Future<void> getAllPendingReceives(String searchText, String userId) async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(
            '${EnvironmentVariables.baseUrl}pedido/recibidos${searchText != '' ? '?idUser=$userId&search=$searchText' : '?idUser=$userId'}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final map = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(map.toString());
    final direcciones = Direccion.fromJsonList(map['body'][0]);
    setState(() {
      receiveList = direcciones;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Buscar...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.white),
                  onChanged: (value) => getAllPendingReceives(
                      value, authBloc2.user['id'].toString()),
                ),
              ),
              const SizedBox(width: 10),
              MaterialButton(
                height: 50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blue,
                child: const Center(
                  child: Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, DeliverScannerView.route);
                },
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Total de despachos pendientes: ${receiveList!.length}'),
        ),
        loading
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Loading... ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              )
            : receiveList!.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getAllPendingReceives(
                            '', authBloc2.user['id'].toString());
                      },
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 30),
                        shrinkWrap: true,
                        // itemCount: 4,
                        itemCount: receiveList!.length,
                        itemBuilder: (context, index) {
                          final Direccion adresses = receiveList![index];
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push<void>(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ReceiveItem(receive: receive),
                              //   ),
                              // );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
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
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: adresses.direciones!.map(
                                            (DireccionDt orderDetail) {
                                              if (orderDetail.recibido == 1) {
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      Icons.label,
                                                      color: orderDetail
                                                                  .entregado !=
                                                              1
                                                          ? Colors.black
                                                          : Colors.green,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      orderDetail.codigo ?? '',
                                                      style: TextStyle(
                                                        color: orderDetail
                                                                    .entregado !=
                                                                1
                                                            ? Colors.black
                                                            : Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(adresses.correlativo ?? ''),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.account_circle_outlined),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child:
                                            Text(adresses.nombreContacto ?? ''),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.pin_drop),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(adresses.direccion ?? ''),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  adresses.reprogramaciones != null &&
                                          adresses.reprogramaciones!.isNotEmpty
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Reprogramaciones: ${adresses.reprogramaciones!.length.toString()}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No hay datos que mostrar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              getAllPendingReceives(
                                  '', authBloc2.user['id'].toString());
                            },
                            child: const Icon(Icons.replay),
                          ),
                        ],
                      ),
                    ),
                  ),
      ],
    );
  }
}
