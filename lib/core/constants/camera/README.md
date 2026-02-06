# Camera Module

Modular camera capture screen dengan face detection untuk Flutter menggunakan **Provider pattern** untuk state management.

## Struktur Folder

```
camera/
├── camera.dart                          # Export file
├── example_usage.dart                   # Contoh penggunaan
├── README.md                            # Dokumentasi
├── controllers/
│   └── camera_controller.dart           # State management controller
├── data/
│   ├── models/
│   │   └── camera_config.dart           # Model konfigurasi
│   └── services/
│       └── face_detection_service.dart  # Service deteksi wajah
├── presentation/
│   └── camera_screens.dart              # Screen utama (stateless)
└── widget/
    ├── camera_view.dart                 # Main view switcher
    ├── camera_live_preview.dart         # Live camera preview
    ├── camera_preview.dart              # Image preview after capture
    ├── camera_bottom_bar.dart           # Bottom controls
    ├── camera_overlay.dart              # Overlay guide
    └── face_overlay_painter.dart        # Custom painter overlay
```

## Arsitektur

### Clean Architecture dengan Provider

```
┌─────────────────────────────────────────┐
│  Presentation Layer (Screens/Widgets)  │
│  - CameraCaptureScreen (Stateless)     │
│  - Widget components (Stateless)       │
└──────────────┬──────────────────────────┘
               │ menggunakan
┌──────────────▼──────────────────────────┐
│  Controller Layer                       │
│  - CameraPageController (ChangeNotifier)│
│  - State management dengan Provider     │
└──────────────┬──────────────────────────┘
               │ menggunakan
┌──────────────▼──────────────────────────┐
│  Data Layer                             │
│  - CameraConfig (Model)                 │
│  - FaceDetectionService                 │
└─────────────────────────────────────────┘
```

## Fitur

- ✅ **Stateless Widgets** - Semua widget UI adalah stateless
- ✅ **Provider Pattern** - State management dengan ChangeNotifier
- ✅ **Face Detection** - Real-time menggunakan ML Kit
- ✅ **Dynamic Config** - Text dan behavior yang customizable
- ✅ **Multiple Presets** - Face Verification, KYC, Profile Photo
- ✅ **Modular Components** - Widget terpisah dan reusable
- ✅ **Clean Code** - Separation of concerns yang jelas

## Cara Menggunakan

### 1. Import Module

```dart
import 'package:latihan_ui/core/constants/camera/camera.dart';
```

### 2. Gunakan dengan Preset Config

#### Face Verification (Default)

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: CameraConfig.faceVerification(),
    ),
  ),
);
```

#### KYC Verification

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: CameraConfig.kycVerification(),
    ),
  ),
);
```

#### Profile Photo

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: CameraConfig.profilePhoto(),
    ),
  ),
);
```

### 3. Custom Configuration

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CameraCaptureScreen(
      config: const CameraConfig(
        title: 'Custom Camera',
        initialInstruction: 'Please position your face...',
        faceDetectedText: '✓ Perfect!',
        // ... konfigurasi lainnya
      ),
    ),
  ),
);
```

## CameraConfig Properties

| Property                 | Type   | Default                                   | Deskripsi                  |
| ------------------------ | ------ | ----------------------------------------- | -------------------------- |
| `title`                  | String | 'Capture Photo'                           | Judul di top bar           |
| `initialInstruction`     | String | 'Looking for face...'                     | Instruksi awal             |
| `noFaceText`             | String | 'No face detected'                        | Text saat tidak ada wajah  |
| `multipleFacesText`      | String | 'Too many faces detected'                 | Text saat banyak wajah     |
| `tooCloseText`           | String | 'Move face away from camera'              | Text saat terlalu dekat    |
| `tooFarText`             | String | 'Move face closer to camera'              | Text saat terlalu jauh     |
| `moveRightText`          | String | 'Move face to the right'                  | Instruksi geser kanan      |
| `moveLeftText`           | String | 'Move face to the left'                   | Instruksi geser kiri       |
| `moveDownText`           | String | 'Move face down'                          | Instruksi geser bawah      |
| `moveUpText`             | String | 'Move face up'                            | Instruksi geser atas       |
| `faceDetectedText`       | String | '✓ Face detected properly!'               | Text saat wajah terdeteksi |
| `capturingText`          | String | 'Capturing photo...'                      | Text saat mengambil foto   |
| `captureSuccessText`     | String | 'Photo captured successfully'             | Text sukses ambil foto     |
| `previewTitle`           | String | 'Photo Preview'                           | Judul preview              |
| `retakeButtonText`       | String | 'Retake'                                  | Text tombol ambil ulang    |
| `confirmButtonText`      | String | 'Use Photo'                               | Text tombol konfirmasi     |
| `ensureFacePositionText` | String | 'Please ensure face is detected properly' | Snackbar warning           |

## Preset Configurations

### 1. Face Verification (Indonesian)

Default configuration untuk verifikasi wajah dengan teks Bahasa Indonesia.

### 2. KYC Verification (Indonesian)

Configuration untuk verifikasi identitas KYC.

### 3. Profile Photo (Indonesian)

Configuration untuk mengambil foto profil yang lebih casual.

## Komponen

### FaceDetectionService

Service terpisah untuk handle face detection menggunakan ML Kit.

**Methods:**

- `processCameraImage()` - Proses gambar kamera dan deteksi wajah
- `dispose()` - Bersihkan resources

### FaceOverlayPainter

Custom painter untuk menampilkan overlay guide dengan oval frame dan corner decorations.

**Features:**

- Dynamic color berdasarkan status deteksi
- Smooth visual feedback
- Corner decorations

## Return Value

Screen akan return `File?` berisi gambar yang di-capture, atau `null` jika dibatalkan.

```dart
if (result != null) {
  // Handle captured image
  File imageFile = result;
  print('Image path: ${imageFile.path}');
}
```

## Dependencies

- `camera`: ^0.10.0+
- `permission_handler`: ^10.0.0+
- `google_mlkit_face_detection`: ^0.9.0+

## Contoh Lengkap

Lihat [example_usage.dart](example_usage.dart) untuk contoh lengkap penggunaan.
