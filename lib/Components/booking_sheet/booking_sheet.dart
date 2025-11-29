import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Controller/locationController.dart';
import '../../Features/cabListPage/model/cabModel.dart';
import '../../Features/cabListPage/screens/cabListPage.dart';

class BookingSheet extends StatefulWidget {
  final List<CabModel> carList;
  const BookingSheet({super.key, required this.carList});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  final MatchController matchController = Get.put(MatchController());
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  // Validation Errors
  String? dateError;
  String? timeError;


  bool validateDateTime() {
    setState(() {
      dateError = pickupDate == null ? "Please select pickup date" : null;
      timeError = pickupTime == null ? "Please select pickup time" : null;
    });

    if (dateError != null || timeError != null) {
      Get.snackbar(
        "Missing Information",
        "Please select date and time",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      matchController.fetchCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Book Your Ride",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _fromLocationField(),

              const SizedBox(height: 15),

              /// To Location
              _locationField(
                label: "To Location",
                icon: Icons.flag_outlined,
                controller: matchController.toController,
                suggestions: matchController.toSuggestions,
                onChanged: (val) => matchController.getToSuggestions(val),
                onSelect: (suggestion) =>
                    matchController.selectToSuggestion(suggestion),
                address: matchController.toAddress,
                latLng: matchController.selectedToLatLng,
              ),

              const SizedBox(height: 15),

              _datePicker(context),
              if (dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(dateError!,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 15),

              _timePicker(context),
              if (timeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(timeError!,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 20),

              /// Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!validateDateTime()) return;

                    final dist = matchController.distanceText.value;
                    final send = (dist == '' ||
                        dist == 'Calculating...' ||
                        dist == 'Distance not available')
                        ? '0 km'
                        : dist;

                    Get.off(() => CabListPage(distance: send));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Get Cab List",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------
  // FROM LOCATION FIELD (GPS → X)
  // -------------------------
  Widget _fromLocationField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: matchController.fromController,
            decoration: InputDecoration(
              labelText: "From Location",
              prefixIcon: const Icon(Icons.location_on_outlined),

              suffixIcon: matchController.isUsingCurrentLocation.value
                  ? IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  matchController.clearFromLocation();
                },
              )
                  : IconButton(
                icon:
                const Icon(Icons.gps_fixed, color: Colors.yellow),
                onPressed: () {
                  matchController.fetchCurrentLocation();
                },
              ),

              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (val) {
              matchController.isUsingCurrentLocation.value = false;
              matchController.getFromSuggestions(val);
            },
          ),

          if (matchController.fromSuggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 6),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: matchController.fromSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion =
                  matchController.fromSuggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      matchController
                          .selectFromSuggestion(suggestion);
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  // -------------------------
  // GENERIC LOCATION FIELD
  // -------------------------
  Widget _locationField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required RxList<String> suggestions,
    required Function(String) onChanged,
    required Function(String) onSelect,
    RxString? address,
    Rx<LatLng?>? latLng,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: onChanged,
          ),

          if (suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 6),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      onSelect(suggestion);
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  // ------------------ DATE PICKER ------------------
  Widget _datePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );

        if (picked != null) {
          setState(() {
            pickupDate = picked;
            dateError = null;
          });
        }
      },
      child: _pickerContainer(
        icon: Icons.calendar_today_outlined,
        text: pickupDate == null
            ? "Select Pickup Date"
            : DateFormat.yMMMd().format(pickupDate!),
      ),
    );
  }

  // ------------------ TIME PICKER ------------------
  Widget _timePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

        if (picked != null) {
          setState(() {
            pickupTime = picked;
            timeError = null;
          });
        }
      },
      child: _pickerContainer(
        icon: Icons.access_time_outlined,
        text: pickupTime == null
            ? "Select Pickup Time"
            : pickupTime!.format(context),
      ),
    );
  }

  Widget _pickerContainer({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
