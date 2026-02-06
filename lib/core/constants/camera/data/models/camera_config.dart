/// Configuration model for camera capture screen
class CameraConfig {
  /// Title shown in top bar
  final String title;

  /// Initial instruction text
  final String initialInstruction;

  /// Text shown when no face is detected
  final String noFaceText;

  /// Text shown when multiple faces detected
  final String multipleFacesText;

  /// Text shown when face is too close
  final String tooCloseText;

  /// Text shown when face is too far
  final String tooFarText;

  /// Text shown when face should move right
  final String moveRightText;

  /// Text shown when face should move left
  final String moveLeftText;

  /// Text shown when face should move down
  final String moveDownText;

  /// Text shown when face should move up
  final String moveUpText;

  /// Text shown when face is detected properly
  final String faceDetectedText;

  /// Text shown during photo capture
  final String capturingText;

  /// Text shown after successful capture
  final String captureSuccessText;

  /// Preview screen title
  final String previewTitle;

  /// Retake button text
  final String retakeButtonText;

  /// Confirm button text
  final String confirmButtonText;

  /// Snackbar message when face not in position
  final String ensureFacePositionText;

  const CameraConfig({
    this.title = 'Capture Photo',
    this.initialInstruction = 'Looking for face...',
    this.noFaceText = 'No face detected',
    this.multipleFacesText = 'Too many faces detected',
    this.tooCloseText = 'Move face away from camera',
    this.tooFarText = 'Move face closer to camera',
    this.moveRightText = 'Move face to the right',
    this.moveLeftText = 'Move face to the left',
    this.moveDownText = 'Move face down',
    this.moveUpText = 'Move face up',
    this.faceDetectedText = '✓ Face detected properly!',
    this.capturingText = 'Capturing photo...',
    this.captureSuccessText = 'Photo captured successfully',
    this.previewTitle = 'Photo Preview',
    this.retakeButtonText = 'Retake',
    this.confirmButtonText = 'Use Photo',
    this.ensureFacePositionText = 'Please ensure face is detected properly',
  });

  /// Default config for face verification
  factory CameraConfig.faceVerification() {
    return const CameraConfig(
      title: 'Verifikasi Wajah',
      initialInstruction: 'Mencari wajah...',
      noFaceText: 'Tidak ada wajah terdeteksi',
      multipleFacesText: 'Terlalu banyak wajah terdeteksi',
      tooCloseText: 'Jauhkan wajah dari kamera',
      tooFarText: 'Dekatkan wajah ke kamera',
      moveRightText: 'Geser wajah ke kanan',
      moveLeftText: 'Geser wajah ke kiri',
      moveDownText: 'Geser wajah ke bawah',
      moveUpText: 'Geser wajah ke atas',
      faceDetectedText: '✓ Wajah terdeteksi dengan baik!',
      capturingText: 'Mengambil foto...',
      captureSuccessText: 'Foto berhasil diambil',
      previewTitle: 'Preview Foto',
      retakeButtonText: 'Ambil Ulang',
      confirmButtonText: 'Gunakan Foto',
      ensureFacePositionText: 'Pastikan wajah terdeteksi dengan baik',
    );
  }

  /// Config for KYC/Identity verification
  factory CameraConfig.kycVerification() {
    return const CameraConfig(
      title: 'Verifikasi Identitas',
      initialInstruction: 'Posisikan wajah Anda...',
      noFaceText: 'Wajah tidak terdeteksi',
      multipleFacesText: 'Hanya satu wajah yang diperbolehkan',
      tooCloseText: 'Terlalu dekat, mundur sedikit',
      tooFarText: 'Terlalu jauh, maju sedikit',
      moveRightText: 'Geser ke kanan',
      moveLeftText: 'Geser ke kiri',
      moveDownText: 'Geser ke bawah',
      moveUpText: 'Geser ke atas',
      faceDetectedText: '✓ Posisi sempurna!',
      capturingText: 'Memproses...',
      captureSuccessText: 'Berhasil diambil',
      previewTitle: 'Konfirmasi Foto',
      retakeButtonText: 'Foto Ulang',
      confirmButtonText: 'Konfirmasi',
      ensureFacePositionText: 'Posisikan wajah dengan benar',
    );
  }

  /// Config for profile photo
  factory CameraConfig.profilePhoto() {
    return const CameraConfig(
      title: 'Foto Profil',
      initialInstruction: 'Siapkan pose terbaik Anda...',
      noFaceText: 'Tidak ada wajah',
      multipleFacesText: 'Terlalu banyak orang',
      tooCloseText: 'Jauhkan sedikit',
      tooFarText: 'Dekatkan sedikit',
      moveRightText: 'Ke kanan',
      moveLeftText: 'Ke kiri',
      moveDownText: 'Ke bawah',
      moveUpText: 'Ke atas',
      faceDetectedText: '✓ Siap!',
      capturingText: 'Smile! 😊',
      captureSuccessText: 'Foto bagus!',
      previewTitle: 'Foto Profil Anda',
      retakeButtonText: 'Ambil Lagi',
      confirmButtonText: 'Pakai Foto Ini',
      ensureFacePositionText: 'Pastikan wajah terlihat jelas',
    );
  }
}
