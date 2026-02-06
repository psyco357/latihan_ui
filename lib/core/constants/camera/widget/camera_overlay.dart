import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/camera_controller.dart';
import 'face_overlay_painter.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CameraPageController>();

    return CustomPaint(
      painter: FaceOverlayPainter(
        faceDetected: c.faceDetected,
        faceInPosition: c.faceInPosition,
      ),
    );
  }
}
