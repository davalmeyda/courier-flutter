import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scanner_qr/features/features.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String route = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usuarioController = TextEditingController(text: 'correo@correo.com');
  final passWordController = TextEditingController(text: 'test@123');

  @override
  void initState() {
    super.initState();
  }

  Future<void> iniciarSesion(String email, String password, context) async {
    debugPrint(email);
    debugPrint(password);
    final response = await http.post(
      Uri.parse('http://192.168.1.73:3000/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    Navigator.pushReplacementNamed(context, ReceiveListView.route);
    //--- RESPUESTA
    debugPrint(response.body);
  }

  void getData() {
    debugPrint(usuarioController.text);
    debugPrint(passWordController.text);
    Navigator.pushNamed(context, ReceiveListView.route);
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
              const Text('Bienvenido'),
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
                  await iniciarSesion(
                      usuarioController.text, passWordController.text, context);
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
