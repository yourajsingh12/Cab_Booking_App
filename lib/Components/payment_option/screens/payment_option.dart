import 'package:flutter/material.dart';
import '../../../../../Res/constant/colors.dart';
import '../../../Res/constant/dialogBox/successDialogbox.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});

  Widget _paymentIcon(BuildContext context, IconData icon, String name) {
    return GestureDetector(
      onTap: () => showThankYouDialog(context),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: UColors.yellow.withOpacity(0.2),
            child: Icon(icon, color: UColors.yellow, size: 28),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _paymentIcon(context, Icons.account_balance_wallet, "PhonePe"),
        _paymentIcon(context, Icons.payment, "Google Pay"),
        _paymentIcon(context, Icons.account_balance, "Bank"),
        _paymentIcon(context, Icons.qr_code, "Scanner"),
      ],
    );
  }
}
