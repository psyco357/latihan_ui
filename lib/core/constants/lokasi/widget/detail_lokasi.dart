import 'package:flutter/material.dart';
import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';
import 'package:provider/provider.dart';

class DetailLokasi extends StatelessWidget {
  const DetailLokasi({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocationController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildLocationDetail(
            'Latitude',
            controller.currentPosition!.latitude.toStringAsFixed(6),
          ),
          const Divider(height: 16),
          _buildLocationDetail(
            'Longitude',
            controller.currentPosition!.longitude.toStringAsFixed(6),
          ),
          const Divider(height: 16),
          _buildLocationDetail(
            'Akurasi',
            '${controller.currentPosition!.accuracy.toStringAsFixed(2)} meter',
          ),
          if (controller.distanceToOfficeMeters != null) ...[
            const Divider(height: 16),
            _buildLocationDetail(
              'Jarak ke Kantor',
              controller.formatDistance(controller.distanceToOfficeMeters!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
