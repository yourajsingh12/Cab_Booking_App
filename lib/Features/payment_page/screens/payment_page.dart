import 'dart:io';
import 'package:cab_booking/Features/dashboard/screens/home.dart';
import 'package:cab_booking/Res/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Components/payment_option/controller/payment_Controller.dart';
import '../../../Components/payment_option/controller/upload_payment.dart';
import '../../../navigator.dart';

class PaymentPage extends StatefulWidget {
  final int bookingId;
  const PaymentPage({super.key, required this.bookingId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final paymentController = Get.put(PaymentController());
  final uploadController = Get.put(UploadReceiptController());

  int selectedIndex = 0;
  File? paymentSS;

  @override
  void initState() {
    super.initState();
    paymentController.fetchBankDetails();
  }

  Future pickScreenshot() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => paymentSS = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment",style: TextStyle(color: Colors.white),),
        backgroundColor: UColors.yellow,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (paymentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (paymentController.bankData == null) {
          return const Center(child: Text("No data found"));
        }

        final bank = paymentController.bankData!;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _toggleButtons(),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    selectedIndex == 0
                        ? _qrCardDynamic(bank.upiQrCode)
                        : _upiCardDynamic(bank.upiId),


                    const SizedBox(height: 15),


                    _sectionTitle("Upload Screenshot"),
                    _uploadCard(),
                    const SizedBox(height: 25),

                    _submitButton(),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }


  Widget _toggleButtons() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _toggleButton("Scan QR", 0),
          _toggleButton("UPI", 1),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: BoxDecoration(
          color: isSelected ? UColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _qrCardDynamic(String qrUrl) {
    return _buildCard(
      Column(
        children: [
          const Text("Scan QR",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            height: 250,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Image.network(qrUrl, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          const Text("Scan using any UPI App",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _upiCardDynamic(String upiId) {
    return _buildCard(
      Row(
        children: [
          const Icon(Icons.payment_rounded, color: UColors.yellow, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(upiId,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _uploadCard() {
    return GestureDetector(
      onTap: pickScreenshot,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: paymentSS == null
            ? const Row(
          children: [
            Icon(Icons.upload, size: 30, color: UColors.yellow),
            SizedBox(width: 10),
            Text("Upload Payment Screenshot",
                style: TextStyle(fontSize: 15)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(paymentSS!, height: 200, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Obx(() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: UColors.yellow,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: uploadController.isUploading.value
            ? null
            : () async {

          bool success = await uploadController.uploadReceipt(
            bookingId: widget.bookingId,
            receiptFile: paymentSS!,
          );

          if (success) {
            Get.snackbar("Success", "Payment receipt uploaded!",
                backgroundColor: Colors.green, colorText: Colors.white);

            Get.offAll(NavigationMenu());
          } else {
            Get.snackbar("Failed", "Could not upload receipt!",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        child: uploadController.isUploading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "Submit",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      );
    });
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: child,
    );
  }
}
