
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:latihan_ui/core/constants/lokasi/controllers/location_controller.dart';
class MapDisplay extends StatelessWidget {
  const MapDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocationController>();
    final position = controller.currentPosition;

    if (position == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
        markers: controller.markers,
        circles: controller.circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController mapController) {
          controller.setMapController(mapController);
        },
      ),
    );
  }
}