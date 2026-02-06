// lib/constant/lokasi/pages/lokasi_pages.dart
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latihan_ui/core/constants/lokasi/widget/map_display.dart';
import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';
import 'package:latihan_ui/core/constants/lokasi/widget/address_display.dart';
import 'package:latihan_ui/core/constants/lokasi/widget/detail_lokasi.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late final LocationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocationController();
    // Langsung ambil lokasi saat page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<LocationController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller.currentPosition != null
                            ? Colors.green[50]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.currentPosition != null
                              ? Colors.green[200]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          controller.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  controller.currentPosition != null
                                      ? Icons.check_circle
                                      : Icons.location_on,
                                  color: controller.currentPosition != null
                                      ? Colors.green[700]
                                      : Colors.grey,
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.locationStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: controller.currentPosition != null
                                    ? Colors.green[900]
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (controller.currentPosition != null) ...[
                      const SizedBox(height: 24),

                      // Map Display
                      const MapDisplay(),
                      const SizedBox(height: 16),

                      // Address Display
                      if (controller.address != null) const AddressDisplay(),

                      const SizedBox(height: 16),

                      const Text(
                        'Detail Koordinat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                      const DetailLokasi(),
                    ],

                    const SizedBox(height: 24),

                    // Buttons
                    if (controller.currentPosition != null)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: controller.isLoading
                                  ? null
                                  : () =>
                                        controller.getCurrentLocation(context),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Ambil Ulang Lokasi'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  controller.confirmLocation(context),
                              icon: const Icon(Icons.check),
                              label: const Text('Gunakan Lokasi'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: const Color(0xFF11CFFF),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
