import 'dart:convert';
import 'package:cab_booking/Res/helper_pref/pref_shareded_helper.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    final phone = await SharedPrefsHelper.getPhone();

    if (phone == null) {
      throw Exception("Phone number not found locally!");
    }

    final url = Uri.parse('https://rodways.site/app/api/bookings/user-bookings/$phone');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        // return list of bookings
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        throw Exception(data["message"] ?? "Failed to fetch bookings");
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }
}
