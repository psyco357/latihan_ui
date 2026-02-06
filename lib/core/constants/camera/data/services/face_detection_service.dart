import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Result of face detection
class FaceDetectionResult {
  final bool faceDetected;
  final bool faceInPosition;
  final String instructionText;

  FaceDetectionResult({
    required this.faceDetected,
    required this.faceInPosition,
    required this.instructionText,
  });
}

/// Service for handling face detection using ML Kit
class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _isDetecting = false;
  int _frameCount = 0;

  /// Process camera image and detect face
  Future<FaceDetectionResult?> processCameraImage({
    required CameraImage cameraImage,
    required String noFaceText,
    required String multipleFacesText,
    required String tooFarText,
    required String tooCloseText,
    required String moveRightText,
    required String moveLeftText,
    required String moveDownText,
    required String moveUpText,
    required String faceDetectedText,
    required bool isAutoCapturing,
  }) async {
    if (_isDetecting) return null;

    _isDetecting = true;
    _frameCount++;

    try {
      final inputImage = _convertToInputImage(cameraImage);
      if (inputImage == null) {
        _isDetecting = false;
        return null;
      }

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _isDetecting = false;
        return FaceDetectionResult(
          faceDetected: false,
          faceInPosition: false,
          instructionText: noFaceText,
        );
      } else if (faces.length > 1) {
        _isDetecting = false;
        return FaceDetectionResult(
          faceDetected: true,
          faceInPosition: false,
          instructionText: multipleFacesText,
        );
      } else {
        final face = faces.first;
        final result = _analyzeFacePosition(
          face: face,
          imageWidth: cameraImage.width,
          imageHeight: cameraImage.height,
          tooFarText: tooFarText,
          tooCloseText: tooCloseText,
          moveRightText: moveRightText,
          moveLeftText: moveLeftText,
          moveDownText: moveDownText,
          moveUpText: moveUpText,
          faceDetectedText: faceDetectedText,
          isAutoCapturing: isAutoCapturing,
        );

        _isDetecting = false;
        return result;
      }
    } catch (e) {
      debugPrint('Error detecting face: $e');
      _isDetecting = false;
      return null;
    }
  }

  /// Analyze face position and provide guidance
  FaceDetectionResult _analyzeFacePosition({
    required Face face,
    required int imageWidth,
    required int imageHeight,
    required String tooFarText,
    required String tooCloseText,
    required String moveRightText,
    required String moveLeftText,
    required String moveDownText,
    required String moveUpText,
    required String faceDetectedText,
    required bool isAutoCapturing,
  }) {
    final boundingBox = face.boundingBox;
    final centerX = boundingBox.center.dx;
    final centerY = boundingBox.center.dy;

    // Check if face is centered
    final screenCenterX = imageWidth / 2.2;
    final screenCenterY = imageHeight / 2.2;
    final toleranceX = imageWidth * 0.55;
    final toleranceY = imageHeight * 0.35;

    final isCenteredX = (centerX - screenCenterX).abs() < toleranceX;
    final isCenteredY = (centerY - screenCenterY).abs() < toleranceY;

    // Check face size
    final faceWidth = boundingBox.width;
    final minWidth = imageWidth * 0.3;
    final maxWidth = imageWidth * 0.7;
    final isSizeOk = faceWidth > minWidth && faceWidth < maxWidth;

    if (!isSizeOk) {
      return FaceDetectionResult(
        faceDetected: true,
        faceInPosition: false,
        instructionText: faceWidth < minWidth ? tooFarText : tooCloseText,
      );
    } else if (!isCenteredX || !isCenteredY) {
      String instruction;
      if (centerX < screenCenterX - toleranceX) {
        instruction = moveRightText;
      } else if (centerX > screenCenterX + toleranceX) {
        instruction = moveLeftText;
      } else if (centerY < screenCenterY - toleranceY) {
        instruction = moveDownText;
      } else {
        instruction = moveUpText;
      }

      return FaceDetectionResult(
        faceDetected: true,
        faceInPosition: false,
        instructionText: instruction,
      );
    } else {
      return FaceDetectionResult(
        faceDetected: true,
        faceInPosition: true,
        instructionText: faceDetectedText,
      );
    }
  }

  /// Convert camera image to InputImage for ML Kit
  InputImage? _convertToInputImage(CameraImage cameraImage) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(
        cameraImage.width.toDouble(),
        cameraImage.height.toDouble(),
      );

      if (_frameCount == 1) {
        debugPrint('Image size: ${imageSize.width}x${imageSize.height}');
        debugPrint('Image format: ${cameraImage.format.group}');
      }

      final InputImageRotation imageRotation = Platform.isAndroid
          ? InputImageRotation.rotation270deg
          : InputImageRotation.rotation0deg;

      final InputImageFormat inputImageFormat = Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;

      if (_frameCount == 1) {
        debugPrint('Using rotation: $imageRotation');
        debugPrint('Using format: $inputImageFormat');
      }

      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: cameraImage.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint('Error converting image: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _faceDetector.close();
  }
}
