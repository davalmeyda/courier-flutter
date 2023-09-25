import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final usuarioController = TextEditingController();
  final passWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // void btnIngresar() {
  //   // Esta es la función que se ejecutará cuando se presione el botón.
  //   debugPrint('hola');
  //   // Puedes realizar cualquier acción que desees aquí.
  // }

  // Future<String> enviarDatos(String parametro1, String parametro2) async {
  //   final url = Uri.parse('http://localhost:3000/users/login');

  //    try {
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'email': parametro1,
  //       'password': parametro2,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final respuesta = jsonDecode(response.body);
  //     String valorDevuelto = respuesta['valor_devuelto'];
  //     return valorDevuelto;
  //   } else {
  //     throw Exception('Error al enviar datos por POST');
  //   }
  // } catch (e) {
  //   // Captura y maneja las excepciones que puedan ocurrir durante la solicitud
  //   throw Exception('Error en la solicitud HTTP: $e');
  // }

  // }

  Future <void> iniciarSesion(String email, String password) async {
    debugPrint(email);
    debugPrint(password);
    final response = await http.post(
      Uri.parse('http://192.168.1.107:3000/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

      //--- RESPUESTA
      debugPrint(response.body);

    

  }

  void getData() {
    debugPrint(usuarioController.text);
    debugPrint(passWordController.text);
    Navigator.of(context).pushNamed('HomeView');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('EXAMPLE 3'),
              const SizedBox(height: 20),
              TextField(
                controller: usuarioController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Usuario'),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passWordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Password'),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                    await iniciarSesion(usuarioController.text, passWordController.text);
                },
                child: const Text('Ingresar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
