import 'package:flutter/material.dart';
import '../../../Res/constant/colors.dart';

class PopularCarCard extends StatelessWidget {
  final String carName;
  final String carImage;
  final bool? isAc;          // 🔥 Nullable now
  final int seats;
  final double price;
  final VoidCallback? onTap;

  const PopularCarCard({
    super.key,
    required this.carName,
    required this.carImage,
    required this.isAc,
    required this.seats,
    required this.price,
    this.onTap,
  });

  IconData _getAcIcon() {
    if (isAc == true) return Icons.ac_unit;       // AC
    if (isAc == false) return Icons.air;          // Non-AC
    return Icons.help_outline;                    // Unknown
  }

  String _getAcText() {
    if (isAc == true) return "AC";
    if (isAc == false) return "Non-AC";
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: UColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 80,
                width: 80,
                color: Colors.white,
                child: FadeInImage(
                  placeholder: const AssetImage("assets/images/loading.gif"),
                  image: NetworkImage(carImage),
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.local_taxi, size: 35, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),


            const SizedBox(width: 15),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        _getAcIcon(),         // 🔥 Dynamic Icon
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getAcText(),         // 🔥 Dynamic Text
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Icon(Icons.people, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "$seats Seats",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Text(
                  //   "₹${price.toStringAsFixed(2)} / km",
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
