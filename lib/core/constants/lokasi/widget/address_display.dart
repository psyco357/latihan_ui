import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';

class AddressDisplay extends StatelessWidget {
  const AddressDisplay({super.key});

  // final String address;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocationController>();
    final address = controller.address;

    if (address == null || address.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Alamat Lokasi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.address!,
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
