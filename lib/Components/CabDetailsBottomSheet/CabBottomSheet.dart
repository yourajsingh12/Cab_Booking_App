import 'package:cab_booking/Res/helper_pref/pref_shareded_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/bookingController.dart';
import '../../Controller/locationController.dart';
import '../../Features/payment_page/screens/payment_page.dart';

class CabBottomSheet {
  static void show({
    required BuildContext context,
    required String cabName,
    required String cabImage,
    required double price,
    required int km,
    required int totalFare,
    required int cabId,
  }) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final matchController = Get.find<MatchController>();

    final isLoading = false.obs;

    void callNumber(String phone) async {
      final Uri url = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar("Error", "Cannot place call");
      }
    }

    SharedPrefsHelper.getPhone().then((value) {
      if (value != null) {
        phoneController.text = value;
      }
    });

    void showBookingSuccessDialog(int bookingId) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Booking Confirmed!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your cab is successfully booked.\nDriver will contact you soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => callNumber("09102265055"),
                  child: const Text(
                    "Contact us: 09102265055",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.to(() => PaymentPage(bookingId: bookingId));
                  },
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(
                        cabImage,
                        height: 70,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      cabName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      rowItem("Price / km", "₹$price"),
                      const Divider(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Fare",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$totalFare",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Your Name *",
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone Number *",
                    prefixIcon: const Icon(Icons.phone),
                    counterText: "",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading.value
                      ? null
                      : () async {
                    if (nameController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Please enter your name",
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                      return;
                    }

                    if (phoneController.text.trim().length != 10) {
                      Get.snackbar("Error",
                          "Please enter valid phone number",
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                      return;
                    }

                    isLoading.value = true;

                    String bookingDate = matchController
                        .selectedDate.value !=
                        null
                        ? DateFormat("yyyy-MM-dd")
                        .format(matchController.selectedDate.value!)
                        : "";

                    String bookingTime = matchController
                        .selectedTime.value !=
                        null
                        ? "${matchController.selectedTime.value!.hour.toString().padLeft(2, '0')}:${matchController.selectedTime.value!.minute.toString().padLeft(2, '0')}"
                        : "";

                    final bookingController =
                    Get.put(BookingController());

                    // ✅ Submit Booking and get result
                    var result = await bookingController.submitBooking(
                      pickupLocation:
                      matchController.fromController.text,
                      dropLocation: matchController.toController.text,
                      distanceKm: km.toDouble(),
                      cabId: cabId,
                      userName: nameController.text.trim(),
                      mobileNo: phoneController.text.trim(),
                      bookingDate: bookingDate,
                      bookingTime: bookingTime,
                      totalFare: totalFare.toString(),
                    );

                    isLoading.value = false;

                    if (result != null &&
                        result["success"] == true) {
                      await SharedPrefsHelper.savePhone(phoneController.text.trim());
                      int bookingId = result["data"]["id"];
                      showBookingSuccessDialog(bookingId);
                    }
                  },
                  child: isLoading.value
                      ? const SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Confirm Booking",
                    style:
                    TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget rowItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
