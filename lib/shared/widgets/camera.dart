import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class CameraScannerWidget extends StatefulWidget {
  final Function(String?) callBack;
  const CameraScannerWidget({Key? key, required this.callBack})
      : super(key: key);

  @override
  State<CameraScannerWidget> createState() => _CameraScannerWidgetState();
}

class _CameraScannerWidgetState extends State<CameraScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.black,
      child: QrCamera(
        onError: (context, error) => Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
        cameraDirection: CameraDirection.BACK,
        qrCodeCallback: widget.callBack,
      ),
    );
  }
}
