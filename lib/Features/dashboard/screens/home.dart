import 'package:cab_booking/Controller/cabController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Components/banners/banner.dart';
import '../../../Components/booking_sheet/booking_sheet.dart';
import '../../../Components/popular_cab/popular_cab.dart';
import '../../../Res/constant/colors.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentBanner = 0;

  final List<String> banners = [
    'https://spn-sta.spinny.com/blog/20220609124009/Spinny-Assured-Maruti-Wagon-R-1.0.jpg',
    'https://imgd.aeplcdn.com/1280x720/n/cw/ec/46045/marutisuzuki-dzire-exterior0.jpeg?wm=0',
    'https://htcms-prod-images.s3.ap-south-1.amazonaws.com/ht/auto/cms-images/marutisuzuki_ertiga/multi-images/colour_marutisuzuki-ertiga_pearl-metallic-arctic-white_600x400_600x338.jpg',
    'https://imgd.aeplcdn.com/664x374/cw/ec/14545/Toyota-Innova-Right-Front-Three-Quarter-72626.jpg?v=201711021421&q=80',
  ];

  final CabController  cabController=Get.put(CabController());

  void openBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSheet(carList: cabController.cabList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.white,
      appBar: AppBar(
        backgroundColor: UColors.yellow,
        elevation: 3,
        shadowColor: Colors.black26,
        title: const Text(
          "Rodways",
          style: TextStyle(
            color: UColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications_none, size: 28, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline, color: Colors.black),
            ),
          ),
        ],
      ),

        body: RefreshIndicator(
          onRefresh: () async {
            await cabController.fetchCabs();  // <-- API या डेटा reload function
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: UColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        BannerSlider(
                          banners: banners,
                          onChanged: (i) => setState(() => currentBanner = i),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed: () => openBookingSheet(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Popular Cars",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(() {
                    if (cabController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: cabController.cabList.map((cab) {
                        return PopularCarCard(
                          carName: cab.name,
                          carImage: cab.image,
                          isAc: cab.isAc,
                          seats: cab.seats,
                          price: cab.pricePerKm,
                          onTap: () => openBookingSheet(context),
                        );
                      }).toList(),
                    );
                  }),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        )
    );
  }
}
