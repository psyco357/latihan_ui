import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/camera_controller.dart';

class CameraBottomBar extends StatelessWidget {
  final CameraPageController controller;

  const CameraBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusBadge(),
              const SizedBox(height: 20),
              _CaptureButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CameraPageController>();

    Color color = Colors.red[400]!;
    IconData icon = Icons.face;

    if (c.faceInPosition) {
      color = Colors.green[400]!;
      icon = Icons.check_circle;
    } else if (c.faceDetected) {
      color = Colors.orange[400]!;
      icon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              c.instructionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CameraPageController>();

    return GestureDetector(
      onTap: () async {
        if (!c.faceInPosition) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(c.config.ensureFacePositionText),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        await c.capture();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: c.faceInPosition ? Colors.green : Colors.white,
            width: 4,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.faceInPosition ? Colors.green : Colors.white,
          ),
          child: c.faceInPosition
              ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
              : null,
        ),
      ),
    );
  }
}
