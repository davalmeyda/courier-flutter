import 'package:flutter/material.dart';
import 'package:scanner_qr/features/auth/auth.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/shared/config/config.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String route = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    LocalPreferences preferences = LocalPreferences();
    preferences.getString('user').then((value) {
      if (value != null) {
        authBloc2.setUser(value);
      }
    });
    authBloc2.userStram.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
      }
    });
  }

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
