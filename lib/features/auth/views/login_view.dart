// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/shared/config/config.dart';
import 'package:scanner_qr/shared/utils/alert.dart';

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

  Future<void> iniciarSesion(
      String email, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${EnvironmentVariables.baseUrl}users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    //--- RESPUESTA
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['statusCode'] == 202) {
      debugPrint(map['body']['id'].toString());
      // context.read<AuthBloc>().add(ChangeIdUser(map['body']['id']));
      authBloc2.setUser(map['body']);
      Navigator.pushReplacementNamed(context, HomeView.route);
    } else {
      showDialog(
        context: context,
        builder: (context) => showSimpleDialog(
          'Error',
          map['message'],
          context,
        ),
      );
    }
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
