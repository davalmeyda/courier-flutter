import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc2.dart';
import 'package:ojo_courier/features/features.dart';
import 'package:ojo_courier/models/models.dart';
import 'package:ojo_courier/shared/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DeliverDetails extends StatefulWidget {
  const DeliverDetails(
      this.adress, this.client, this.deliverAgency, this.deliverLocation,
      {super.key});
  final Direccion? adress;
  final Cliente? client;
  final Agencia? deliverAgency;
  final Ubicacion? deliverLocation;

  @override
  State<DeliverDetails> createState() => _DeliverDetailsState();
}

class _DeliverDetailsState extends State<DeliverDetails> {
  int? amount = 0;
  String? paymentType = 'AL CONTADO';
  List<File>? deliverPhotos = [];
  bool loading = false;

  Future<void> confirmDelivery() async {
    setState(() {
      loading = true;
    });
    if (deliverPhotos == null || deliverPhotos!.isEmpty) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe adjuntar una imagen'),
          duration: Duration(milliseconds: 1000),
        ),
      );
      return;
    }

    final idDireccion = widget.adress!.id;

    final body = json.encode({
      'direccionId': idDireccion,
      'idUser': authBloc2.user!.id,
      'importe': amount,
      'forma_pago': paymentType,
    });

    final response = await http.put(
      Uri.parse('${EnvironmentVariables.baseUrl}pedido/entregar/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    final map = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      setState(() {
        loading = false;
      });
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => showSimpleDialog(
          'Error',
          map['message'],
          context,
        ),
      );
      return;
    }

    // List<DireccionDt> orders =
    //     widget.adress?.direciones != null ? widget.adress!.direciones! : [];

    // for (var order in orders) {
    //   if (order.recibido == 0) {
    //     setState(() {
    //       loading = false;
    //     });
    //     if (!context.mounted) return;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('No ha sido recibido'),
    //         duration: Duration(milliseconds: 1000),
    //       ),
    //     );
    //     return;
    //   }
    //   final response = await http.put(
    //     Uri.parse(
    //         '${EnvironmentVariables.baseUrl}pedido/entregar/${order.pedido?.codigo}?idUser=${authBloc2.user!.id}&importe=$amount&forma_pago=$paymentType'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //   );

    //   final map = json.decode(response.body) as Map<String, dynamic>;

    //   if (response.statusCode != 200) {
    //     setState(() {
    //       loading = false;
    //     });
    //     if (!context.mounted) return;
    //     showDialog(
    //       context: context,
    //       builder: (context) => showSimpleDialog(
    //         'Error',
    //         map['message'],
    //         context,
    //       ),
    //     );
    //     return;
    //   }
    // }

    for (var element in deliverPhotos!) {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${EnvironmentVariables.baseUrl}pedido/imagenDespacho/${widget.adress?.id}?user_id=${authBloc2.user!.id}&importe=$amount'),
      );
      request.files.add(
        http.MultipartFile(
          'imagen',
          element.readAsBytes().asStream(),
          element.lengthSync(),
          filename: element.path.split('/').last,
        ),
      );
      final respImg = await request.send();
      if (respImg.statusCode != 200) {
        setState(() {
          loading = false;
        });
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => showSimpleDialog(
            'Error',
            'Error al subir la imagen',
            context,
          ),
        );
        return;
      }
    }

    setState(() {
      loading = false;
    });
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: CardWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Correlativo:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.adress!.correlativo ?? '',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              widget.adress!.direccion != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.direccion != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dirección:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.direccion ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.departamento != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.departamento != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Departamento:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.departamento ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.provincia != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.provincia != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Provincia:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.provincia ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.distrito != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.distrito != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distrito:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.distrito ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.referencia != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.referencia != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Referencia:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.referencia ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.observaciones != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.observaciones != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Observaciones:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.observaciones ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.dniRuc != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.dniRuc != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Documento:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.dniRuc ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.adress!.nombreContacto != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.adress!.nombreContacto != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contacto:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.adress!.nombreContacto ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.client?.nombre != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.client?.nombre != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cliente:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${widget.client?.dni != null ? '${widget.client?.dni} / ' : ''}${widget.client?.nombre ?? ''}',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.client?.dni != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.client?.dni != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DNI Cliente:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.client?.dni ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.client?.celular != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.client?.celular != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Celular del Cliente:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.client?.celular.toString() ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.deliverAgency?.nombreAgencia != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.deliverAgency?.nombreAgencia != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agencia:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.deliverAgency?.nombreAgencia ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.deliverLocation?.nombreUbicacion != null
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.deliverLocation?.nombreUbicacion != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Destino:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.deliverLocation?.nombreUbicacion ?? '',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pedidos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: widget.adress!.direciones!.map(
                        (DireccionDt orderDetail) {
                          if (orderDetail.recibido != 0) {
                            return Text(
                              orderDetail.codigo ?? '',
                              textAlign: TextAlign.right,
                            );
                          }
                          return const SizedBox();
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              widget.deliverAgency?.id == 3
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Importe',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            fillColor: Colors.white),
                        onChanged: (value) => {
                          setState(() {
                            amount = int.parse(value);
                          })
                        },
                        keyboardType: TextInputType.number,
                      ),
                    )
                  : const SizedBox(),
              widget.deliverAgency?.id == 3
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              widget.deliverAgency?.id == 3
                  ? DropdownButton<String>(
                      value: paymentType,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (newValue) {
                        setState(() {
                          paymentType = newValue;
                        });
                      },
                      items: <String>['AL CONTADO', 'CONTRA ENTREGA']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  : const SizedBox(),
              widget.deliverAgency?.id == 3
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFiles =
                          await picker.pickMultiImage(maxWidth: 800);
                      if (pickedFiles.isNotEmpty) {
                        final List<File> compressedImages = [];
                        for (var pickedFile in pickedFiles) {
                          var result = await compressImage(pickedFile);
                          compressedImages.add(result);
                        }
                        setState(() {
                          deliverPhotos = compressedImages;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Galería',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                          source: ImageSource.camera, maxWidth: 800);
                      if (pickedFile != null) {
                        final List<File> compressedImages = deliverPhotos ?? [];
                        var result = await compressImage(pickedFile);
                        compressedImages.add(result);
                        setState(() {
                          deliverPhotos = compressedImages;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 16, 136, 145),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Cámara',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                itemCount: deliverPhotos!.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.file(
                            deliverPhotos![index],
                            // width: 80,
                            height: 80,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              deliverPhotos!.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return DeliverRejectView(
                          deliver: widget.adress!,
                        );
                      },
                    ));
                  },
                  child: const Text(
                    'No entregado',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              widget.adress?.reprogramaciones != null &&
                      widget.adress!.reprogramaciones!.length == 2
                  ? const SizedBox()
                  : const SizedBox(height: 10),
              widget.adress?.reprogramaciones != null &&
                      widget.adress!.reprogramaciones!.length == 2
                  ? const SizedBox()
                  : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliverRescheduleView(
                                  deliver: widget.adress!,
                                ),
                              ));
                        },
                        child: const Text(
                          'Reprogramar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: loading
                      ? null
                      : deliverPhotos!.isEmpty
                          ? null
                          : () => confirmDelivery(),
                  child: const Text(
                    'Entregado',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
