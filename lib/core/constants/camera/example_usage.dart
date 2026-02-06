import 'package:flutter/material.dart';
import 'package:latihan_ui/core/constants/camera/camera.dart';

/// Example usage of CameraCaptureScreen with different configurations

// Example 1: Face Verification (Default)
void openFaceVerificationCamera(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          CameraCaptureScreen(config: CameraConfig.faceVerification()),
    ),
  );

  if (result != null) {
    // Handle captured image
    print('Image captured: ${result.path}');
  }
}

// Example 2: KYC Verification
void openKYCCamera(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          CameraCaptureScreen(config: CameraConfig.kycVerification()),
    ),
  );

  if (result != null) {
    // Handle KYC image
    print('KYC image: ${result.path}');
  }
}

// Example 3: Profile Photo
void openProfilePhotoCamera(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          CameraCaptureScreen(config: CameraConfig.profilePhoto()),
    ),
  );

  if (result != null) {
    // Handle profile photo
    print('Profile photo: ${result.path}');
  }
}

// Example 4: Custom Configuration
void openCustomCamera(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraCaptureScreen(
        config: const CameraConfig(
          title: 'Custom Camera',
          initialInstruction: 'Please position your face...',
          noFaceText: 'No face found',
          multipleFacesText: 'Multiple faces detected',
          tooCloseText: 'Too close',
          tooFarText: 'Too far',
          moveRightText: 'Move right',
          moveLeftText: 'Move left',
          moveDownText: 'Move down',
          moveUpText: 'Move up',
          faceDetectedText: '✓ Perfect!',
          capturingText: 'Capturing...',
          captureSuccessText: 'Success!',
          previewTitle: 'Preview',
          retakeButtonText: 'Retake',
          confirmButtonText: 'Confirm',
          ensureFacePositionText: 'Please position correctly',
        ),
      ),
    ),
  );

  if (result != null) {
    // Handle custom captured image
    print('Custom image: ${result.path}');
  }
}
