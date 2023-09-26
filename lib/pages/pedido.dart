import 'dart:convert';

import 'package:flutter/material.dart';

class PantallaMostrarDatos extends StatelessWidget {
  final String datos;

  const PantallaMostrarDatos({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> jsonData = jsonDecode(datos);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mostrar Datos x')
      ),
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: jsonData.keys.map((key) {
            final value = jsonData[key];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
