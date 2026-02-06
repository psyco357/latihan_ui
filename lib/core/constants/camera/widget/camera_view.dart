import 'package:flutter/material.dart';
import '../controllers/camera_controller.dart';
import 'camera_preview.dart';
import 'camera_live_preview.dart';
import 'camera_bottom_bar.dart';

class CameraView extends StatelessWidget {
  final CameraPageController controller;

  const CameraView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.capturedImage != null) {
      return CameraPreviewImage(controller: controller);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraLivePreview(controller: controller),
        CameraBottomBar(controller: controller),
      ],
    );
  }
}
