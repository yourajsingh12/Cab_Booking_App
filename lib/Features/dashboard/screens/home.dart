import 'package:flutter/material.dart';
import '../../../Components/banners/banner.dart';
import '../../../Components/book_button.dart';
import '../../../Components/booking_sheet/booking_sheet.dart';
import '../../../Components/categories/categories_list.dart';
import '../../../Res/constant/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentBanner = 0;


  final List<String> banners = [
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
    'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?w=800',
    'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800',
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Car', 'icon': Icons.directions_car},
    {'name': 'Bike', 'icon': Icons.motorcycle},
    {'name': 'Auto', 'icon': Icons.electric_rickshaw},
    {'name': 'Rental', 'icon': Icons.car_rental},
    {'name': 'Luxury', 'icon': Icons.local_taxi},
    {'name': 'Outstation', 'icon': Icons.directions_bus},
  ];

  final List<String> carList = [
    'Dzire',
    'Ertiga',
    'Innova',
    'Crysta',
    'Scorpio',
    'Fortuner',
  ];

  void openBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSheet(carList: carList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.white,
      appBar: AppBar(
        title: const Text(
          'Cab Booking',
          style: TextStyle(color: UColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: UColors.yellow,
        centerTitle: true,
        elevation: 0,
        actions: const [
          Icon(Icons.notifications_none, color: UColors.black, size: 28),
          SizedBox(width: 15),
          CircleAvatar(
            backgroundColor: UColors.white,
            radius: 15,
            child: Icon(Icons.person_outline, color: UColors.black),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: UColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  BannerSlider(
                    banners: banners,
                    onChanged: (index) =>
                        setState(() => currentBanner = index),
                  ),
                  CategoryList(categories: categories),
                  BookButton(onPressed: () => openBookingSheet(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
