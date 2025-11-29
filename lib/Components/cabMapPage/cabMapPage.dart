import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/locationController.dart';

class CabMap extends StatelessWidget {
  final MatchController controller;
  final BitmapDescriptor? cabIcon;
  final Function(GoogleMapController) onMapCreated;

  const CabMap({
    super.key,
    required this.controller,
    required this.cabIcon,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: controller.selectedToLatLng.value ?? const LatLng(28.6139, 77.2090),
          zoom: 14,
        ),
        polylines: controller.polylineCoords.isEmpty
            ? {}
            : {
          Polyline(
            polylineId: const PolylineId("route"),
            points: controller.polylineCoords,
            width: 6,
            color: Colors.blue,
          ),
        },
        markers: {
          if (controller.selectedToLatLng.value != null)
            Marker(
              markerId: const MarkerId("start"),
              position: controller.selectedToLatLng.value!,
              infoWindow: const InfoWindow(title: "Start (To)"),
            ),
          if (controller.selectedFromLatLng.value != null)
            Marker(
              markerId: const MarkerId("end"),
              position: controller.selectedFromLatLng.value!,
              infoWindow: const InfoWindow(title: "End (From)"),
            ),
          if (controller.cabPosition.value != null)
            Marker(
              markerId: const MarkerId("cab"),
              position: controller.cabPosition.value!,
              icon: cabIcon ?? BitmapDescriptor.defaultMarker,
            ),
        },
        onMapCreated: onMapCreated,
      );
    });
  }
}