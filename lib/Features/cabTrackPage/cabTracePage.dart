import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Components/book_button.dart';
import '../../Components/cabMapPage/cabMapPage.dart';
import '../../Components/payment_option/screens/payment_option.dart';
import '../../Controller/locationController.dart';
import '../../../../Res/constant/colors.dart';


class CabTracePage extends StatefulWidget {
  const CabTracePage({super.key});

  @override
  State<CabTracePage> createState() => _CabTracePageState();
}

class _CabTracePageState extends State<CabTracePage> {
  final MatchController controller = Get.put(MatchController());
  GoogleMapController? mapController;
  BitmapDescriptor? cabIcon;

  @override
  void initState() {
    super.initState();
    _loadCabIcon();
  }

  void _loadCabIcon() async {
    cabIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      "assets/cab.png",
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Track Your Ride"),
        backgroundColor: UColors.yellow,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.5,
            child: CabMap(
              controller: controller,
              cabIcon: cabIcon,
              onMapCreated: (gmCtrl) {
                mapController = gmCtrl;
                Future.delayed(const Duration(milliseconds: 300), _fitPolylineToScreen);
              },
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Options 💳",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  PaymentOptions(),
                  const SizedBox(height: 30),
                  CompleteRideButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fitPolylineToScreen() {
    if (controller.polylineCoords.isEmpty || mapController == null) return;

    double x0 = controller.polylineCoords.first.latitude;
    double x1 = controller.polylineCoords.first.latitude;
    double y0 = controller.polylineCoords.first.longitude;
    double y1 = controller.polylineCoords.first.longitude;

    for (LatLng latLng in controller.polylineCoords) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1)),
        40,
      ),
    );
  }
}



