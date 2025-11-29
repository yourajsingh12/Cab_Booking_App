import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Res/constant/colors.dart';
import '../Controller/locationController.dart';
import '../Features/dashboard/screens/home.dart';
import '../Res/constant/dialogBox/successDialogbox.dart';

class BookButton extends StatelessWidget {
  final VoidCallback onPressed;
  const BookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: UColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        "Book Ride",
        style: TextStyle(
          color: UColors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CompleteRideButton extends StatelessWidget {
  final MatchController controller;
  const CompleteRideButton({super.key, required this.controller});

  void _showCompleteRideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
              "If you click OK, you will complete the ride and cannot return to the map."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.offAll(() => Dashboard());
                showThankYouDialog(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () => _showCompleteRideDialog(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
            ),
            child: const Text(
              "Complete Ride",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}