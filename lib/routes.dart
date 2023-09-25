import 'package:flutter/material.dart';
import 'package:scanner_qr/pages/home.dart';
import 'package:scanner_qr/pages/login.dart';
import 'pages/example.dart';

Map<String, WidgetBuilder> getRutas() {
  return {
    'HomeView': (context) => const MyHomePage(),
    'LoginPage': (context) => const LoginPage(),
    'ExamplePage': (context) => const ExamplePage(),
  };
}
