import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../Services/location.dart';

class MatchController extends GetxController {
  final LocationService locationService = LocationService();

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final RxList<String> fromSuggestions = <String>[].obs;
  final RxList<String> toSuggestions = <String>[].obs;

  final Rx<LatLng?> selectedFromLatLng = Rx<LatLng?>(null);
  final Rx<LatLng?> selectedToLatLng = Rx<LatLng?>(null);

  final RxString fromAddress = ''.obs;
  final RxString toAddress = ''.obs;

  final RxString distanceText = ''.obs;
  final RxDouble distanceValue = 0.0.obs;

  final RxList<String> directionsSteps = <String>[].obs;

  final RxList<LatLng> polylineCoords = <LatLng>[].obs;
  final Rx<LatLng?> cabPosition = Rx<LatLng?>(null);

  var isUsingCurrentLocation = false.obs;

  final String apiKey = 'AIzaSyDgx4T1sLieAkSh9wvvZfUalG0LrMF7lUg';

  Timer? _timer;
  int polyIndex = 0;

  // ✅ ADDED — date & time fields
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(TimeOfDay.now());

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  // CLEAR FROM LOCATION
  void clearFromLocation() {
    fromController.clear();
    fromAddress.value = "";
    selectedFromLatLng.value = null;
    isUsingCurrentLocation.value = false;
    fromSuggestions.clear();
    directionsSteps.clear();
  }

  // ---------------- CURRENT LOCATION ----------------
  Future<void> fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          Get.snackbar("Permission Denied", "Location permission required");
          return;
        }
      }

      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final address = await locationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );

      isUsingCurrentLocation.value = true;
      fromAddress.value = address;
      selectedFromLatLng.value = LatLng(position.latitude, position.longitude);
      fromController.text = address;
      fromSuggestions.clear();

      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  // ---------------- AUTOCOMPLETE ----------------
  Future<void> getFromSuggestions(String input) async {
    if (input.isEmpty) {
      fromSuggestions.clear();
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        fromSuggestions.value = List<String>.from(
          data['predictions'].map((p) => p['description']),
        );
      } else {
        fromSuggestions.clear();
      }
    } catch (e) {
      fromSuggestions.clear();
    }
  }

  Future<void> getToSuggestions(String input) async {
    if (input.isEmpty) {
      toSuggestions.clear();
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        toSuggestions.value = List<String>.from(
          data['predictions'].map((p) => p['description']),
        );
      } else {
        toSuggestions.clear();
      }
    } catch (e) {
      toSuggestions.clear();
    }
  }

  // ---------------- SELECT FROM ----------------
  Future<void> selectFromSuggestion(String place) async {
    fromController.text = place;
    fromSuggestions.clear();

    final location = await locationService.getLatLngFromPlace(place);
    if (location != null) {
      selectedFromLatLng.value = location;

      fromAddress.value = await locationService.reverseGeocode(
        location.latitude,
        location.longitude,
      );
    }

    _calculateDistanceAndPolyline();
  }

  // ---------------- SELECT TO ----------------
  Future<void> selectToSuggestion(String place) async {
    toController.text = place;
    toSuggestions.clear();

    final location = await locationService.getLatLngFromPlace(place);
    if (location != null) {
      selectedToLatLng.value = location;

      toAddress.value = await locationService.reverseGeocode(
        location.latitude,
        location.longitude,
      );
    }

    _calculateDistanceAndPolyline();
  }

  // ---------------- CALCULATE DISTANCE + ROUTE ----------------
  Future<void> _calculateDistanceAndPolyline() async {
    if (selectedFromLatLng.value == null ||
        selectedToLatLng.value == null) return;

    final directions = await locationService.getDirections(
      selectedFromLatLng.value!,
      selectedToLatLng.value!,
      apiKey,
    );

    if (directions != null) {
      polylineCoords.value = directions['polyline'];
      directionsSteps.value = directions['steps'];
      distanceText.value = directions['distanceText'];
      distanceValue.value = directions['distanceValue'];

      if (polylineCoords.isNotEmpty) {
        cabPosition.value = polylineCoords.first;
        _startCabAnimation();
      }
    }
  }

  // ---------------- CAB ANIMATION ----------------
  void _startCabAnimation() {
    polyIndex = 0;

    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(milliseconds: 900), (Timer timer) {
          if (polyIndex < polylineCoords.length) {
            cabPosition.value = polylineCoords[polyIndex];
            polyIndex++;
          } else {
            timer.cancel();
          }
        });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
