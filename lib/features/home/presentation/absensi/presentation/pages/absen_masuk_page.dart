import 'package:flutter/material.dart';
// import 'package:latihan_ui/core/constants/test_camera/presentation/camera_screens.dart';
import 'package:latihan_ui/core/constants/camera/camera.dart';

class AbsenMasukPage extends StatelessWidget {
  const AbsenMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Absen Masuk')),
      body: CameraCaptureScreen(config: CameraConfig.kycVerification()),

      // body: CameraCaptureWidget(),
    );
  }
}
