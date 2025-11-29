import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  /// Distance Matrix API
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

  /// Simple Polyline route
  Future<List<LatLng>> getRoutePolyline(LatLng from, LatLng to) async {
    List<LatLng> polylineCoords = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var p in result.points) {
        polylineCoords.add(LatLng(p.latitude, p.longitude));
      }
    } else {
      print("Polyline Error: ${result.errorMessage}");
    }

    return polylineCoords;
  }

  /// ---------- NEW → Directions API with steps ----------
  Future<Map<String, dynamic>?> getDirections(LatLng from, LatLng to, String apiKey) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&mode=driving&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] != 'OK') return null;

      // Polyline points
      final points = data['routes'][0]['overview_polyline']['points'];
      final polylinePoints = PolylinePoints().decodePolyline(points);
      final polyline =
      polylinePoints.map((p) => LatLng(p.latitude, p.longitude)).toList();

      // Distance
      final leg = data['routes'][0]['legs'][0];
      final distanceText = leg['distance']['text'];
      final distanceValue = leg['distance']['value'];

      // Step-by-step directions
      final stepsData = leg['steps'] as List;
      final steps = stepsData.map((step) {
        final htmlInstruction = step['html_instructions'] as String;
        return htmlInstruction.replaceAll(RegExp(r'<[^>]*>'), '');
      }).toList();

      return {
        'polyline': polyline,
        'distanceText': distanceText,
        'distanceValue': distanceValue,
        'steps': steps,
      };
    } catch (e) {
      print("Directions API error: $e");
      return null;
    }
  }
}
