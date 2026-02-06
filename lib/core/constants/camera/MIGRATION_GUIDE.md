# Camera Module - Migration Guide

## Perubahan Arsitektur

### Sebelum (Stateful)

```dart
// Stateful widget dengan logic di dalam
class CameraCaptureScreen extends StatefulWidget {
  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  // 400+ baris code dengan:
  // - Camera initialization
  // - Face detection logic
  // - UI building
  // - State management
  // Semua tercampur dalam satu file!
}
```

### Sesudah (Stateless + Provider)

```dart
// Stateless widget yang ringan
class CameraCaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraPageController(config: config)..init(),
      child: const _CameraScreenBody(),
    );
  }
}
```

## Keuntungan Arsitektur Baru

### 1. **Separation of Concerns**

- ✅ **Controller**: Logic & state management
- ✅ **Service**: Face detection logic
- ✅ **Widget**: UI components saja
- ✅ **Model**: Configuration data

### 2. **Reusability**

Semua widget bisa digunakan ulang:

```dart
// Bisa pakai di screen lain
CameraBottomBar(controller: myController)
CameraPreview(controller: myController)
```

### 3. **Testability**

Controller bisa di-test tanpa UI:

```dart
test('should detect face', () {
  final controller = CameraPageController();
  // Test logic tanpa widget tree
});
```

### 4. **Maintainability**

- File lebih kecil dan fokus
- Mudah menemukan bug
- Mudah menambah fitur

## Struktur File

### Controllers (State Management)

**camera_controller.dart** (120 baris)

- Mengelola state (isLoading, faceDetected, dll)
- Camera initialization
- Koordinasi dengan service
- Notify listeners saat ada perubahan

### Services (Business Logic)

**face_detection_service.dart** (200 baris)

- Face detection dengan ML Kit
- Image conversion
- Face position analysis
- Reusable di project lain

### Widgets (UI Components)

**camera_screens.dart** (40 baris)

- Entry point screen
- Setup Provider
- Minimal logic

**camera_view.dart** (25 baris)

- Switch antara live preview & image preview

**camera_live_preview.dart** (75 baris)

- Show camera feed
- Overlay dan top bar

**camera_preview.dart** (100 baris)

- Show captured image
- Retake & confirm buttons

**camera_bottom_bar.dart** (125 baris)

- Status badge
- Capture button
- User interactions

### Models (Data)

**camera_config.dart** (140 baris)

- Semua text yang bisa di-customize
- Preset configs (Face Verification, KYC, Profile)

## Cara Menggunakan

### Basic Usage

```dart
import 'package:latihan_ui/core/constants/camera/camera.dart';

// Pakai preset
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: CameraConfig.faceVerification(),
    ),
  ),
);
```

### Custom Usage

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: const CameraConfig(
        title: 'Scan KTP',
        initialInstruction: 'Posisikan wajah Anda',
        faceDetectedText: '✓ Wajah terdeteksi!',
        // ... custom config lainnya
      ),
    ),
  ),
);
```

### Manual Controller Usage (Advanced)

```dart
// Untuk custom screen sendiri
class MyCustomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraPageController(
        config: CameraConfig.kycVerification(),
      )..init(),
      child: Consumer<CameraPageController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Text('Face detected: ${controller.faceDetected}'),
              CameraBottomBar(controller: controller),
              // Custom widgets Anda
            ],
          );
        },
      ),
    );
  }
}
```

## Migration Checklist

Jika ada code lama yang masih menggunakan StatefulWidget:

- [ ] Hapus StatefulWidget, ganti dengan StatelessWidget
- [ ] Move state ke CameraPageController
- [ ] Wrap dengan ChangeNotifierProvider
- [ ] Gunakan context.watch<CameraPageController>() untuk akses state
- [ ] Move face detection logic ke FaceDetectionService
- [ ] Move hardcoded text ke CameraConfig
- [ ] Split UI ke widget-widget kecil

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  camera: ^0.10.0+4
  permission_handler: ^11.0.0
  google_mlkit_face_detection: ^0.9.0
```

## Best Practices

### 1. Jangan Akses Controller di Build Method Langsung

❌ **Salah:**

```dart
Widget build(BuildContext context) {
  final controller = CameraPageController(); // SALAH!
  return Text(controller.instructionText);
}
```

✅ **Benar:**

```dart
Widget build(BuildContext context) {
  final controller = context.watch<CameraPageController>();
  return Text(controller.instructionText);
}
```

### 2. Gunakan Consumer untuk Partial Rebuild

```dart
// Hanya rebuild widget yang perlu
Consumer<CameraPageController>(
  builder: (context, controller, child) {
    return Text(controller.instructionText);
  },
)
```

### 3. Dispose Controller dengan Benar

Controller otomatis di-dispose oleh Provider, tapi pastikan:

```dart
@override
void dispose() {
  cameraController?.dispose();
  _faceDetectionService.dispose();
  super.dispose();
}
```

## Troubleshooting

### Provider not found

```
Error: Could not find the correct Provider<CameraPageController>
```

**Solution:** Pastikan CameraView ada di dalam ChangeNotifierProvider tree.

### State tidak update

**Solution:** Pastikan panggil `notifyListeners()` di controller setelah update state.

### Memory leak

**Solution:** Pastikan dispose camera controller dan service di controller.dispose().

## Perbandingan Line of Code

| File                | Before | After | Reduction        |
| ------------------- | ------ | ----- | ---------------- |
| camera_screens.dart | 719    | 40    | -94%             |
| Total module        | 719    | ~700  | Better organized |

Walaupun total line masih sama, code sekarang:

- ✅ Lebih terorganisir
- ✅ Lebih mudah di-maintain
- ✅ Lebih reusable
- ✅ Lebih testable
