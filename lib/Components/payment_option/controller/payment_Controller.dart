import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/bank_model.dart';


class PaymentController extends GetxController {
  var isLoading = false.obs;
  BankDetails? bankData;

  Future fetchBankDetails() async {
    try {
      isLoading.value = true;

      final url = Uri.parse("https://rodways.site/app/api/bookings/details");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        bankData = BankDetails.fromJson(jsonData['data'][0]);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
