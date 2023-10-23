import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ojo_courier/models/models.dart';
import 'package:ojo_courier/shared/shared.dart';

import 'package:ojo_courier/features/auth/bloc/auth_bloc2.dart';
import 'package:intl/intl.dart';

String defaultMessage =
    'Estimado%20cliente%2C%20%F0%9F%99%8B%F0%9F%8F%BC%E2%80%8D%E2%99%82%EF%B8%8F%F0%9F%99%8B%F0%9F%8F%BB%E2%80%8D%E2%99%80%EF%B8%8F%0ALe%20saluda%2C%20Motorizado%20Courier.%0ALe%20escribo%20para%20informarle%20que%20para%20el%20d%C3%ADa%20de%20hoy%20se%20le%20estar%C3%A1%20contactando%2C%20para%20la%20entrega%20de%20un%20documento%20que%20tengo%20a%20su%20nombre%2C%20le%20pedimos%20su%20colaboraci%C3%B3n%20en%20el%20envi%C3%B3%20de%20su%20ubicaci%C3%B3n%20actual%2C%20para%20la%20entrega%20del%20sobre.%20%C2%A1Que%20tenga%20un%20buen%20d%C3%ADa!';

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
    getAllPendingReceives(
        '', authBloc2.user != null ? authBloc2.user!.id.toString() : '0');
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
                  onChanged: (value) => getAllPendingReceives(
                      value, authBloc2.user!.id.toString()),
                ),
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
                            '', authBloc2.user!.id.toString());
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
                            child: CardWidget(
                              color: adresses.reprogramaciones != null &&
                                      adresses.reprogramaciones!.length == 2
                                  ? Colors.red[300]
                                  : Colors.white,
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
                                  adresses.reprogramaciones != null &&
                                          adresses.reprogramaciones!.isNotEmpty
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: adresses.reprogramaciones !=
                                                          null &&
                                                      adresses.reprogramaciones!
                                                              .length ==
                                                          2
                                                  ? Colors.white
                                                  : Colors.red,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Reprogramaciones: ${adresses.reprogramaciones!.length.toString()}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: adresses.reprogramaciones !=
                                                              null &&
                                                          adresses.reprogramaciones!
                                                                  .length ==
                                                              2
                                                      ? Colors.white
                                                      : Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
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
                                  adresses.idAgencia == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  adresses.idAgencia == null
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.business_outlined,
                                              color: adresses.idAgencia == 1
                                                  ? Colors.orange
                                                  : adresses.idAgencia == 2
                                                      ? Colors.purple
                                                      : Colors.blue,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                adresses.agencia ?? '',
                                                style: TextStyle(
                                                  color: adresses.idAgencia == 1
                                                      ? Colors.orange
                                                      : adresses.idAgencia == 2
                                                          ? Colors.purple
                                                          : Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(adresses
                                                .fecha_asig_motorizado!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  adresses.idUbicacion == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  adresses.idUbicacion == null
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              color: adresses.idUbicacion == 1
                                                  ? Colors.brown
                                                  : Colors.green,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                adresses.ubicacion ?? '',
                                                style: TextStyle(
                                                  color:
                                                      adresses.idUbicacion == 1
                                                          ? Colors.brown
                                                          : Colors.green,
                                                ),
                                              ),
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
                                  adresses.celulares == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 20),
                                  adresses.celulares == null
                                      ? const SizedBox()
                                      : LaunchButtonWidget(
                                          url: 'tel:${adresses.celulares}',
                                          label:
                                              'Llamar: ${adresses.celulares}',
                                          errorLabel:
                                              'No se pudo iniciar la llamada',
                                          icon: Icons.phone,
                                        ),
                                  adresses.googleMaps == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  adresses.googleMaps == null
                                      ? const SizedBox()
                                      : LaunchButtonWidget(
                                          url: adresses.googleMaps ?? '',
                                          label: 'Google Maps',
                                          errorLabel:
                                              'No se pudo iniciar la aplicación',
                                          icon: Icons.pin_drop,
                                        ),
                                  adresses.celulares == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  adresses.celulares == null
                                      ? const SizedBox()
                                      : LaunchButtonWidget(
                                          url:
                                              'https://wa.me/51${adresses.celulares}?text=$defaultMessage',
                                          label: 'Contactar por WhatsApp',
                                          errorLabel:
                                              'No se pudo abrir WhatsApp',
                                          // icon: Icons.phone,
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
                                  '',
                                  authBloc2.user != null
                                      ? authBloc2.user!.id.toString()
                                      : '0');
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
