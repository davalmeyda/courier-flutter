import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc2.dart';
import 'package:ojo_courier/features/features.dart';
import 'package:ojo_courier/models/user.entity.dart';
import 'package:ojo_courier/shared/shared.dart';

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({super.key});

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final usuarioController = TextEditingController();
  final passWordController = TextEditingController();

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

    final map = json.decode(response.body) as Map<String, dynamic>;
    if (!context.mounted) return;
    if (map['statusCode'] == 202) {
      final user = User.fromJson(map['body']);
      authBloc2.setUser(user);
      _navigateToHome(context);
    } else {
      _showErrorDialog(map['message'], context);
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomeView.route);
  }

  void _showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => showSimpleDialog(
        'Error',
        errorMessage,
        context,
      ),
    );
  }

  void getData() {
    Navigator.pushNamed(context, ReceiveListView.route);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () async {
                  await iniciarSesion(
                      usuarioController.text, passWordController.text, context);
                },
                child: const Text('Ingresar'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
