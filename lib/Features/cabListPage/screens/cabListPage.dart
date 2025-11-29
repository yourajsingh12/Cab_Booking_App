import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Components/CabDetailsBottomSheet/CabBottomSheet.dart';
import '../../../Controller/cabController.dart';
import '../../../Res/constant/colors.dart';


class CabListPage extends StatelessWidget {
  final String distance;
  CabListPage({super.key, required this.distance});

  final CabController cabController = Get.put(CabController());

  @override
  Widget build(BuildContext context) {
    final double km = double.tryParse(distance.replaceAll("km", "").trim()) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cab List"),
        backgroundColor: UColors.yellow,
      ),

      body: Obx(() {
        if (cabController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cabController.cabList.isEmpty) {
          return const Center(child: Text("No cabs available"));
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: cabController.cabList.length,
            itemBuilder: (context, index) {
              final cab = cabController.cabList[index];

              double totalFare = km * 2 * cab.pricePerKm;

              return GestureDetector(
                onTap: () {
                  CabBottomSheet.show(
                    context: context,
                    cabName: cab.name,
                    cabImage: cab.image,
                    price: cab.pricePerKm,
                    km: km.toInt(),
                    totalFare: totalFare.toInt(),
                    cabId: cab.id,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // -------- CAB IMAGE --------
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 80,
                          width: 80,
                          color: Colors.white,  // background for contain effect
                          child: FadeInImage(
                            placeholder: const AssetImage("assets/images/loading.gif"),
                            image: NetworkImage(cab.image),
                            fit: BoxFit.contain,     // ✅ FULL IMAGE, NO CROP
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
                      // -------- CAB DETAILS --------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CAB NAME
                            Text(
                              cab.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            const SizedBox(height: 4),
                            // DISTANCE
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.red),
                                const SizedBox(width: 4),

                                Expanded(
                                  child: Text(
                                    "${km.toStringAsFixed(1)} km",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    "₹${totalFare.toInt()}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          ),
        );
      }),
    );
  }
}
