import 'package:flutter/material.dart';
// import 'package:latihan_ui/core/constants/test_camera/presentation/camera_screens.dart';
import 'package:latihan_ui/core/constants/camera/camera.dart';

class AbsenKeluarPage extends StatelessWidget {
  const AbsenKeluarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Absen Keluar')),
      body: CameraCaptureScreen(config: CameraConfig.kycVerification()),

      // body: CameraCaptureWidget(),
    );
  }
}
