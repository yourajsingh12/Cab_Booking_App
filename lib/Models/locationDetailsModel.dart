import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetail {
  final String formattedAddress;
  final LatLng location;

  LocationDetail({
    required this.formattedAddress,
    required this.location,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      formattedAddress: json['formattedAddress'],
      location: LatLng(
        json['location']['latitude'],
        json['location']['longitude'],
      ),
    );
  }
}