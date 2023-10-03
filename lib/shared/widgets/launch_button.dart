import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LaunchButtonWidget extends StatelessWidget {
  final String url;
  final String label;
  final IconData? icon;
  final String? errorLabel;

  const LaunchButtonWidget({
    Key? key,
    required this.url,
    required this.label,
    required this.errorLabel,
    this.icon,
  }) : super(key: key);

  _launchWhatsApp(BuildContext context) async {
    try {
      await launchUrlString(url, mode: LaunchMode.platformDefault);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Algo salió mal'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _launchWhatsApp(context);
        },
        child: Row(
          children: [
            icon != null ? Icon(icon) : const SizedBox(),
            icon != null ? const SizedBox(width: 10) : const SizedBox(),
            Text(label),
          ],
        ),
      ),
    );
  }
}
