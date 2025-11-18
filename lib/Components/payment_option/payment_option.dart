import 'package:flutter/material.dart';
import '../../../../Res/constant/colors.dart';
import '../../Res/constant/dialogBox/successDialogbox.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select Payment Method 💳",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: UColors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _paymentIcon(context, Icons.account_balance_wallet, "PhonePe"),
              _paymentIcon(context, Icons.payment, "Google Pay"),
              _paymentIcon(context, Icons.account_balance, "Bank"),
              _paymentIcon(context, Icons.qr_code, "Scanner"),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _paymentIcon(BuildContext context, IconData icon, String name) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        showThankYouDialog(context);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: UColors.yellow,
            child: Icon(icon, color: UColors.black, size: 28),
          ),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
