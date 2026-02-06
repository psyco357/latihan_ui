import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';
import '../data/models/camera_config.dart';
import '../controllers/camera_controller.dart';
import '../widget/camera_view.dart';

class CameraCaptureScreen extends StatelessWidget {
  final CameraConfig config;

  const CameraCaptureScreen({super.key, this.config = const CameraConfig()});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CameraPageController(config: config)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationController()..init(context),
        ),
      ],
      child: const _CameraScreenBody(),
    );
  }
}

class _CameraScreenBody extends StatelessWidget {
  const _CameraScreenBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CameraPageController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : CameraView(controller: controller),
    );
  }
}
