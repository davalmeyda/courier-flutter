import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PhoneButtonWidget extends StatelessWidget {
  final String phone;

  const PhoneButtonWidget({Key? key, this.phone = ''}) : super(key: key);

  _launchPhone(BuildContext context) async {
    final phoneNumber = 'tel:$phone';
    if (await canLaunchUrlString(phoneNumber)) {
      await launchUrlString(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo iniciar la llamada: $phoneNumber'),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _launchPhone(context);
        },
        child: const Text('Llamar'),
      ),
    );
  }
}
