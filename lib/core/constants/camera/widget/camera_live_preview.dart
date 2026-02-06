import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../controllers/camera_controller.dart';
import 'camera_overlay.dart';
import 'text_lokasi_pengguna.dart';

class CameraLivePreview extends StatelessWidget {
  final CameraPageController controller;

  const CameraLivePreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.cameraController == null ||
        !controller.cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(controller.cameraController!)),
        const CameraOverlay(),

        const LokasiPengguna(),
        _CameraTopBar(controller: controller),
      ],
    );
  }
}

class _CameraTopBar extends StatelessWidget {
  final CameraPageController controller;

  const _CameraTopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  controller.config.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
