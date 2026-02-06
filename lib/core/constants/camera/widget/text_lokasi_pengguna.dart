import 'package:flutter/material.dart';
import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';
import 'package:provider/provider.dart';

class LokasiPengguna extends StatelessWidget {
  const LokasiPengguna({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocationController>();
    final position = controller.currentPosition;
    final distance = controller.distanceToOfficeMeters;
    final distanceText = distance != null
        ? controller.formatDistance(distance)
        : '-';
    final coordinateText = position != null
        ? '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}'
        : '-';

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.14,
      left: 0,
      right: 0,
      // child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.7), // garis saja
            width: 1.2,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lokasi anda dari Kantor: $distanceText',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Titik anda: $coordinateText',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Foto akan diambil secara otomatis saat wajah terdeteksi dengan baik',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
