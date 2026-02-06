import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends ChangeNotifier {
  static const LatLng _officeLocation = LatLng(-6.282956, 106.911897);
  static const double _officeRadiusMeters = 50;

  Position? _currentPosition;
  bool _isLoading = false;
  String _locationStatus = 'Mengambil lokasi...';
  String? _address;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  double? _distanceToOfficeMeters;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get locationStatus => _locationStatus;
  String? get address => _address;
  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;
  double? get distanceToOfficeMeters => _distanceToOfficeMeters;

  String formatDistance(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(2)} km';
    }

    return '${meters.toStringAsFixed(0)} m';
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> init(BuildContext context) async {
    await getCurrentLocation(context);
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    _isLoading = true;
    _locationStatus = 'Mengambil lokasi...';
    notifyListeners();

    try {
      final locationStatus = await Permission.location.request();

      if (locationStatus.isGranted) {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _locationStatus = 'GPS tidak aktif';
          notifyListeners();
          _showLocationServiceDialog(context);
          return;
        }

        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        _currentPosition = position;
        _locationStatus = 'Lokasi berhasil diambil';
        _distanceToOfficeMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _officeLocation.latitude,
          _officeLocation.longitude,
        );
        notifyListeners();

        await _getAddressFromLatLng(position);
        _updateMarker(position);
      } else if (locationStatus.isPermanentlyDenied) {
        _locationStatus = 'Izin lokasi ditolak';
        notifyListeners();
        _showPermissionDialog(context);
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _locationStatus = 'Error: $e';
      notifyListeners();
      _showErrorDialog(context, 'Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void confirmLocation(BuildContext context) {
    if (_currentPosition != null) {
      Navigator.pop(context, _currentPosition);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        _address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        notifyListeners();
      }
    } catch (e) {
      _address = 'Alamat tidak tersedia';
      notifyListeners();
    }
  }

  void _updateMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId('office_location'),
      position: _officeLocation,
      infoWindow: InfoWindow(
        title: 'Lokasi Kantor',
        snippet: 'Radius ${_officeRadiusMeters.toStringAsFixed(0)} m',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    final circle = Circle(
      circleId: const CircleId('office_radius'),
      center: _officeLocation,
      radius: _officeRadiusMeters,
      strokeWidth: 2,
      strokeColor: Colors.blueAccent,
      fillColor: Colors.blueAccent.withOpacity(0.12),
    );

    _markers = {marker};
    _circles = {circle};
    notifyListeners();

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _officeLocation, zoom: 16.0),
      ),
    );
  }

  void _showLocationServiceDialog(BuildContext context) {
    if (!context.mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS Tidak Aktif'),
        content: const Text('Silakan aktifkan GPS untuk melanjutkan absensi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              getCurrentLocation(context);
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    if (!context.mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Lokasi Diperlukan'),
        content: const Text(
          'Aplikasi memerlukan akses lokasi untuk absensi. '
          'Silakan aktifkan di pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (context.mounted) {
                Navigator.pop(context);
              }
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

  void _showErrorDialog(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
