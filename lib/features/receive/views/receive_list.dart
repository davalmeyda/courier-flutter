import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:scanner_qr/models/models.dart';
import 'package:scanner_qr/shared/shared.dart';

import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';

class ReceiveListView extends StatefulWidget {
  const ReceiveListView({super.key});
  static const String route = 'ReceiveListView';
  @override
  State<ReceiveListView> createState() => _ReceiveListViewState();
}

class _ReceiveListViewState extends State<ReceiveListView> {
  bool loading = false;
  List<Direccion>? receiveList = [];

  @override
  void initState() {
    super.initState();
    getAllPendingReceives('', authBloc2.userId.toString());
  }

  Future<void> getAllPendingReceives(String searchText, String userId) async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(
            '${EnvironmentVariables.baseUrl}pedido/pendientes${searchText != '' ? '?idUser=$userId&search=$searchText' : '?idUser=$userId'}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['statusCode'] == 200) {
      debugPrint(map.toString());
      final direcciones = Direccion.fromJsonList(map['body'][0]);
      setState(() {
        receiveList = direcciones;
        loading = false;
      });
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(map['message']),
          duration: const Duration(milliseconds: 1000),
        ),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                  onChanged: (value) =>
                      getAllPendingReceives(value, authBloc2.userId.toString()),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Total de recibos pendientes: ${receiveList!.length}'),
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
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        getAllPendingReceives('', authBloc2.userId.toString());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 30),
                        shrinkWrap: true,
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
                            child: CardWidget(
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
                                              return Row(
                                                children: [
                                                  Icon(
                                                    Icons.label,
                                                    color:
                                                        orderDetail.recibido !=
                                                                1
                                                            ? Colors.black
                                                            : Colors.green,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    orderDetail.codigo ?? '',
                                                    style: TextStyle(
                                                      color: orderDetail
                                                                  .recibido !=
                                                              1
                                                          ? Colors.black
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              );
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
                                        child: Text(
                                            adresses.nombreContacto ?? '-'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.pin_drop),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(adresses.direccion ?? '-'),
                                      ),
                                    ],
                                  ),
                                  adresses.empresaTransporte == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  adresses.empresaTransporte == null
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.business_outlined),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                  adresses.empresaTransporte ??
                                                      ''),
                                            ),
                                          ],
                                        ),
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
                                  '', authBloc2.userId.toString());
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
