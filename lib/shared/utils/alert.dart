import 'package:flutter/material.dart';

showSimpleDialog(
    String titleMessage, String contentMessage, BuildContext context) {
  return AlertDialog(
    title: Text(titleMessage),
    content: Text(contentMessage),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Aceptar'),
      ),
    ],
  );
}
