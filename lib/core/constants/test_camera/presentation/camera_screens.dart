// lib/constant/camera/pages/camera_pages.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraCaptureWidget extends StatefulWidget {
  const CameraCaptureWidget({super.key});

  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isLoading = true;
  File? _capturedImage;
  String _instructionText = 'Mencari wajah...';
  bool _isAutoCapturing = false;

  // ML Kit Face Detection
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.1, // Lebih sensitif untuk mendeteksi wajah lebih kecil
      performanceMode: FaceDetectorMode.accurate, // Lebih akurat
    ),
  );

  bool _isDetecting = false;
  bool _faceDetected = false;
  bool _faceInPosition = false;
  int _frameCount = 0; // Untuk debugging tanpa spam log

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameraStatus = await Permission.camera.request();

      if (!cameraStatus.isGranted) {
        if (cameraStatus.isPermanentlyDenied) {
          _showPermissionDialog();
        } else {
          if (mounted) Navigator.pop(context);
        }
        return;
      }

      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorDialog('Kamera tidak tersedia');
        return;
      }

      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      // Start face detection stream
      _cameraController!.startImageStream(_processCameraImage);

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    if (_isDetecting || _capturedImage != null) return;
    _isDetecting = true;
    _frameCount++;

    try {
      final inputImage = _convertToInputImage(cameraImage);
      if (inputImage == null) {
        debugPrint('Failed to convert camera image');
        _isDetecting = false;
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);

      // Log setiap 30 frame (sekitar 1 detik)
      // if (_frameCount % 30 == 0) {
      //   debugPrint('Frame #$_frameCount - Faces detected: ${faces.length}');
      // }

      if (mounted) {
        setState(() {
          _faceDetected = faces.isNotEmpty;

          if (faces.isEmpty) {
            _instructionText = 'Tidak ada wajah terdeteksi';
            _faceInPosition = false;
          } else if (faces.length > 1) {
            _instructionText = 'Terlalu banyak wajah terdeteksi';
            _faceInPosition = false;
          } else {
            final face = faces.first;

            // Check face position (center of screen)
            final boundingBox = face.boundingBox;
            final centerX = boundingBox.center.dx;
            final centerY = boundingBox.center.dy;

            // Check if face is centered (tolerance: 30% from center)
            final screenCenterX = cameraImage.width / 2;
            final screenCenterY = cameraImage.height / 2;
            final toleranceX = cameraImage.width * 0.22;
            final toleranceY = cameraImage.height * 0.30;

            final isCenteredX = (centerX - screenCenterX).abs() < toleranceX;
            final isCenteredY = (centerY - screenCenterY).abs() < toleranceY;

            // Check face size (should be reasonable)
            final faceWidth = boundingBox.width;
            final minWidth = cameraImage.width * 0.3;
            final maxWidth = cameraImage.width * 0.7;
            final isSizeOk = faceWidth > minWidth && faceWidth < maxWidth;

            if (!isSizeOk) {
              if (faceWidth < minWidth) {
                _instructionText = 'Dekatkan wajah ke kamera';
              } else {
                _instructionText = 'Jauhkan wajah dari kamera';
              }
              _faceInPosition = false;
            } else if (!isCenteredX || !isCenteredY) {
              if (centerX < screenCenterX - toleranceX) {
                _instructionText = 'Geser wajah ke kanan';
              } else if (centerX > screenCenterX + toleranceX) {
                _instructionText = 'Geser wajah ke kiri';
              } else if (centerY < screenCenterY - toleranceY) {
                _instructionText = 'Geser wajah ke bawah';
              } else if (centerY > screenCenterY + toleranceY) {
                _instructionText = 'Geser wajah ke atas';
              }
              _faceInPosition = false;
            } else {
              _instructionText = '✓ Wajah terdeteksi dengan baik!';
              _faceInPosition = true;

              _triggerAutoCapture();
            }
          }
        });
      }
    } catch (e) {
      // debugPrint('Error detecting face: $e');
    }

    _isDetecting = false;
  }

  Future<void> _retakePicture() async {
    if (!_cameraController!.value.isInitialized) return;

    setState(() {
      _capturedImage = null;
      _isAutoCapturing = false;
      _faceInPosition = false;
      _instructionText = 'Arahkan wajah ke kamera';
    });

    try {
      await _cameraController!.startImageStream(_processCameraImage);
    } catch (e) {
      debugPrint('Failed to restart image stream: $e');
    }
  }

  Future<void> _triggerAutoCapture() async {
    if (_isAutoCapturing) return;
    if (_capturedImage != null) return;
    if (!_faceInPosition) return;
    if (!_cameraController!.value.isInitialized) return;

    _isAutoCapturing = true;

    // STOP stream SEKARANG
    await _cameraController!.stopImageStream();

    if (!mounted) return;

    setState(() {
      _instructionText = 'Jangan bergerak...';
    });

    // delay biar kamera stabil
    await Future.delayed(const Duration(milliseconds: 600));

    // SAFETY CHECK
    if (!_faceInPosition || _capturedImage != null) {
      _isAutoCapturing = false;
      await _cameraController!.startImageStream(_processCameraImage);
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();
      final imageFile = File(image.path);

      setState(() {
        _capturedImage = imageFile;
        _instructionText = 'Foto berhasil diambil';
        _isAutoCapturing = false;
      });
    } catch (e) {
      _isAutoCapturing = false;
      await _cameraController!.startImageStream(_processCameraImage);
    }
  }

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

      // Log info hanya sekali
      if (_frameCount == 1) {
        debugPrint('Image size: ${imageSize.width}x${imageSize.height}');
        debugPrint('Image format: ${cameraImage.format.group}');
      }

      // Front camera biasanya butuh rotasi 270 derajat di Android
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

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    // Check if face is in position before capturing
    if (!_faceInPosition) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan wajah terdeteksi dengan baik'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Stop image stream
      await _cameraController!.stopImageStream();

      setState(() => _instructionText = 'Mengambil foto...');

      await Future.delayed(const Duration(milliseconds: 500));

      final XFile image = await _cameraController!.takePicture();
      final imageFile = File(image.path);

      setState(() {
        _capturedImage = imageFile;
        _instructionText = 'Foto berhasil diambil';
      });
    } catch (e) {
      _showErrorDialog('Gagal mengambil foto: $e');
      setState(() => _instructionText = 'Mencari wajah...');
      // Restart image stream
      _cameraController!.startImageStream(_processCameraImage);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Kamera Diperlukan'),
        content: const Text(
          'Aplikasi memerlukan akses kamera untuk absensi. '
          'Silakan aktifkan di pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmImage() {
    if (_capturedImage != null) {
      Navigator.pop(context, _capturedImage);
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _capturedImage != null
          ? _buildPreview()
          : _buildCameraView(),
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Preview
        Center(child: CameraPreview(_cameraController!)),

        // Overlay dengan Frame Guide
        _buildOverlay(),

        _buildFaceInstructionText(),
        // Top Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
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
                  const Expanded(
                    child: Text(
                      'Verifikasi Wajah',
                      style: TextStyle(
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
        ),

        // Bottom Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _faceInPosition
                          ? Colors.green[400]
                          : _faceDetected
                          ? Colors.orange[400]
                          : Colors.red[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _faceInPosition
                              ? Icons.check_circle
                              : _faceDetected
                              ? Icons.warning
                              : Icons.face,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _instructionText,
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
                  ),

                  const SizedBox(height: 20),

                  // Capture Button
                  GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _faceInPosition ? Colors.green : Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _faceInPosition ? Colors.green : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _faceInPosition
                            ? const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaceInstructionText() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'Pastikan wajah berada di dalam area',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return CustomPaint(
      painter: FaceOverlayPainter(
        faceDetected: _faceDetected,
        faceInPosition: _faceInPosition,
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(_capturedImage!, fit: BoxFit.contain),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: const Text(
                'Preview Foto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _retakePicture();
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text(
                        'Ambil Ulang',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _confirmImage,
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'Gunakan Foto',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF11CFFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk Face Overlay
class FaceOverlayPainter extends CustomPainter {
  final bool faceDetected;
  final bool faceInPosition;

  FaceOverlayPainter({
    required this.faceDetected,
    required this.faceInPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final center = Offset(size.width / 2.2, size.height / 2.2);
    final ovalWidth = size.width * 0.55;
    final ovalHeight = size.height * 0.35;
    final innerOval = Rect.fromCenter(
      center: center,
      width: ovalWidth,
      height: ovalHeight,
    );

    final path = Path()
      ..addRect(outerRect)
      ..addOval(innerOval)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Oval border color changes based on face detection
    final borderPaint = Paint()
      ..color = faceInPosition
          ? Colors.green
          : faceDetected
          ? Colors.orange
          : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawOval(innerOval, borderPaint);
  }

  @override
  bool shouldRepaint(FaceOverlayPainter oldDelegate) {
    return oldDelegate.faceDetected != faceDetected ||
        oldDelegate.faceInPosition != faceInPosition;
  }
}
