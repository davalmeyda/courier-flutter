import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'dart:convert';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/models/models.dart';
import 'package:scanner_qr/shared/config/config.dart';

class ReceiveListView extends StatefulWidget {
  const ReceiveListView({super.key});
  static const String route = 'ReceiveListView';
  @override
  State<ReceiveListView> createState() => _ReceiveListViewState();
}

class _ReceiveListViewState extends State<ReceiveListView> {
  bool loading = false;
  List<Pedido>? receiveList = [];

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
            '${EnvironmentVariables.baseUrl}pedido/pendientes${searchText != '' ? '?idUser=$userId&search=$searchText' : '?idUser=$userId'}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final map = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(map.toString());
    final pedidos = Pedido.fromJsonList(map['body'][0]);
    setState(() {
      receiveList = pedidos;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final receiveBloc = context.read<ReceiveBloc>().state;
    // final receiveList = receiveBloc.receiveList;
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
                  Navigator.pushNamed(context, ReceiveScannerView.route);
                },
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
                      onRefresh: () async {
                        getAllPendingReceives(
                            '', authBloc2.user['id'].toString());
                      },
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 30),
                        shrinkWrap: true,
                        itemCount: receiveList!.length,
                        itemBuilder: (context, index) {
                          final Pedido receive = receiveList![index];
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
                                      const Icon(Icons.label),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(receive.codigo ?? ''),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(receive.correlativo ?? ''),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  receive.direccionDt.direccion.correlativo !=
                                          null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.abc),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(receive.direccionDt
                                                  .direccion.correlativo!),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  receive.direccionDt.direccion.correlativo !=
                                          null
                                      ? const SizedBox(height: 10)
                                      : const SizedBox(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.account_circle_outlined),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(receive.cRazonsocial ?? ''),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.event),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child:
                                            Text(receive.createdAt.toString()),
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
