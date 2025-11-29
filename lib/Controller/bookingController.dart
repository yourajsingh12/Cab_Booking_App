import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  var isLoading = false.obs;

  Future<Map<String, dynamic>?> submitBooking({
    final String? pickupLocation,
    final String? dropLocation,
    final double? distanceKm,
    final int? cabId,
    final String? userName,
    final String? mobileNo,
    final String? bookingDate,
    final String? bookingTime,
    final String? totalFare,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("https://rodways.site/app/api/bookings/submit");

      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final body = {
        "pickup_location": pickupLocation,
        "drop_location": dropLocation,
        "distance_km": distanceKm,
        "cab_id": cabId,
        "user_name": userName,
        "mobile_no": mobileNo,
        "booking_date": bookingDate,
        "booking_time": bookingTime,
        "total_price": totalFare
      };

      // 🔥 PRINT FULL REQUEST
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("📡 SENDING REQUEST");
      print("URL: $url");
      print("Headers: $headers");
      print("Body: $body");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      isLoading.value = false;

      // 🔥 PRINT FULL RESPONSE
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("📥 RESPONSE RECEIVED");
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        Get.snackbar("Error", "Booking failed! Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      isLoading.value = false;

      print("❌ Exception: $e");

      Get.snackbar("Error", e.toString());
      return null;
    }
  }
}
