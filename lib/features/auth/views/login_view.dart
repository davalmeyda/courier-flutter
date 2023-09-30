import 'package:flutter/material.dart';
import 'package:scanner_qr/features/auth/auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String route = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: SignInFormWidget(),
        ),
      ),
    );
  }
}
