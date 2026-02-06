import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/camera_config.dart';
import '../data/services/face_detection_service.dart';

class CameraPageController extends ChangeNotifier {
  final CameraConfig config;

  CameraController? cameraController;
  List<CameraDescription>? cameras;

  bool isLoading = true;
  bool faceDetected = false;
  bool faceInPosition = false;
  bool _isAutoCapturing = false;

  String instructionText = '';
  File? capturedImage;

  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  CameraPageController({CameraConfig? config})
    : config = config ?? const CameraConfig() {
    instructionText = this.config.initialInstruction;
  }

  Future<void> init() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    cameras = await availableCameras();
    final frontCamera = cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras!.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize();
    cameraController!.startImageStream(processCameraImage);

    isLoading = false;
    notifyListeners();
  }

  Future<void> processCameraImage(CameraImage image) async {
    if (capturedImage != null) return;

    final result = await _faceDetectionService.processCameraImage(
      cameraImage: image,
      noFaceText: config.noFaceText,
      multipleFacesText: config.multipleFacesText,
      tooFarText: config.tooFarText,
      tooCloseText: config.tooCloseText,
      moveRightText: config.moveRightText,
      moveLeftText: config.moveLeftText,
      moveDownText: config.moveDownText,
      moveUpText: config.moveUpText,
      faceDetectedText: config.faceDetectedText,
      isAutoCapturing: _isAutoCapturing,
    );

    if (result != null) {
      faceDetected = result.faceDetected;
      faceInPosition = result.faceInPosition;
      instructionText = result.instructionText;
      notifyListeners();

      /// 🔥 AUTO CAPTURE TRIGGER
      if (faceInPosition && !_isAutoCapturing && capturedImage == null) {
        _startAutoCapture();
      }
    }
  }

  Future<void> capture() async {
    if (!faceInPosition || capturedImage != null) return;

    await cameraController!.stopImageStream();
    instructionText = config.capturingText;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final file = await cameraController!.takePicture();
    capturedImage = File(file.path);
    instructionText = config.captureSuccessText;
    notifyListeners();
  }

  Future<void> _startAutoCapture() async {
    _isAutoCapturing = true;
    instructionText = config.capturingText;
    notifyListeners();

    // delay biar UI kebaca (UX lebih enak)
    await Future.delayed(const Duration(milliseconds: 700));

    // pastikan masih valid
    if (faceInPosition && capturedImage == null) {
      await capture();
    }

    _isAutoCapturing = false;
  }

  void reset() {
    capturedImage = null;
    instructionText = config.initialInstruction;
    faceInPosition = false;
    faceDetected = false;
    _isAutoCapturing = false;
    cameraController!.startImageStream(processCameraImage);
    notifyListeners();
  }

  @override
  void dispose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    _faceDetectionService.dispose();
    super.dispose();
  }
}
