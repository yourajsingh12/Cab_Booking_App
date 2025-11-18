import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final String apiKey = 'AIzaSyDgx4T1sLieAkSh9wvvZfUalG0LrMF7lUg';

  /// Convert place to LatLng
  Future<LatLng?> getLatLngFromPlace(String place) async {
    final encoded = Uri.encodeComponent(place);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$encoded&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final loc = data['results'][0]['geometry']['location'];
        return LatLng(loc['lat'], loc['lng']);
      }
    } catch (e) {
      print("Geocode Error: $e");
    }
    return null;
  }

  /// Reverse Geocode
  Future<String> reverseGeocode(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      }
    } catch (e) {
      print("Reverse Error: $e");
    }
    return "Unknown location";
  }

  /// ---------- NEW → Google Distance Matrix API ----------
  Future<Map<String, dynamic>?> getDistance(LatLng from, LatLng to) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json"
          "?origins=${from.latitude},${from.longitude}"
          "&destinations=${to.latitude},${to.longitude}"
          "&key=$apiKey",
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == "OK") {
        final element = data['rows'][0]['elements'][0];
        return {
          "text": element['distance']['text'],   // "12.3 km"
          "value": element['distance']['value']  // meters
        };
      }
    } catch (e) {
      print("Distance API error: $e");
    }

    return null;
  }
}
