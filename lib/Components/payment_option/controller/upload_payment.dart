import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UploadReceiptController extends GetxController {
  var isUploading = false.obs;
  String? receiptUrl;
  String? paymentStatus;

  Future<bool> uploadReceipt({
    required int bookingId,
    required File receiptFile,
  }) async {
    try {
      isUploading.value = true;

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://rodways.site/app/api/bookings/upload-receipt"),
      );

      request.fields["booking_id"] = bookingId.toString();

      request.files.add(
        await http.MultipartFile.fromPath("receipt", receiptFile.path),
      );

      var response = await request.send();
      var result = await http.Response.fromStream(response);

      if (result.statusCode == 200) {
        final decoded = jsonDecode(result.body);

        receiptUrl = decoded["data"]["receipt_url"];
        paymentStatus = decoded["data"]["payment_status"];

        return true;
      }
      return false;
    } catch (e) {
      print("Upload Error: $e");
      return false;
    } finally {
      isUploading.value = false;
    }
  }
}
