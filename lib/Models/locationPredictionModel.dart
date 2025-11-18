import 'package:google_maps_flutter/google_maps_flutter.dart';

// LocationPrediction
class LocationPrediction {
  final String placeId;
  final String text;

  LocationPrediction({required this.placeId, required this.text});

  factory LocationPrediction.fromJson(Map<String, dynamic> json) {
    final prediction = json['placePrediction'] ?? json['queryPrediction'] ?? json;
    return LocationPrediction(
      placeId: prediction['placeId'] ?? '',
      text: prediction['text']['text'] ?? '',
    );
  }
}

// LocationSuggestionResponse
class LocationSuggestionResponse {
  final List<LocationPrediction> suggestions;

  LocationSuggestionResponse({required this.suggestions});

  factory LocationSuggestionResponse.fromJson(Map<String, dynamic> json) {
    final suggestions = ((json['suggestions'] ?? []) as List)
        .map((item) => LocationPrediction.fromJson(item))
        .toList();
    return LocationSuggestionResponse(suggestions: suggestions);
  }
}



class LocationDetail {
  final String formattedAddress;
  final LatLng location;

  LocationDetail({required this.formattedAddress, required this.location});

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      formattedAddress: json['formattedAddress'] ?? '',
      location: LatLng(
        json['location']['latitude'] ?? 0.0,
        json['location']['longitude'] ?? 0.0,
      ),
    );
  }
}


