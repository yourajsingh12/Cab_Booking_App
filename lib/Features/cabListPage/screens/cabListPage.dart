import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Components/CabDetailsBottomSheet/CabBottomSheet.dart';

class CabListPage extends StatelessWidget {
  final String distance;  // ex: "12 km"
  CabListPage({super.key, required this.distance});

  /// Cab Data
  final List<Map<String, dynamic>> cabs = [
    {"name": "Dzire", "price": 12, "image": "assets/images/1.png"},
    {"name": "Ertiga", "price": 15, "image": "assets/images/2.png"},
    {"name": "Innova", "price": 20, "image": "assets/images/3.png"},
  ];

  @override
  Widget build(BuildContext context) {

    // extract number
    final double km = double.tryParse(
      distance.replaceAll("km", "").trim(),
    ) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cab List"),
        backgroundColor: Colors.yellow,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: cabs.length,
          itemBuilder: (context, index) {
            final cab = cabs[index];

            /// Total Fare
            double totalFare = km * cab["price"];

            return GestureDetector(
              onTap: () {
                CabBottomSheet.show(
                  context: context,
                  cabName: cab["name"],
                  cabImage: cab["image"],
                  price: cab["price"],
                  km: km.toInt(),
                  totalFare: totalFare.toInt(),
                );
              },

              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        cab["image"],
                        height: 110,
                        width: 110,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cab["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(Icons.currency_rupee,
                                    size: 18, color: Colors.green),
                                Text(
                                  "${cab["price"]}/km",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "₹${totalFare.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blueGrey, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "Distance: ${km.toStringAsFixed(1)} km",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
