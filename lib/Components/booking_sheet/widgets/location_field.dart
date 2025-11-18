import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isFromLocation;
  final RxList<String> suggestions;
  final RxBool isUsingCurrentLocation;
  final Function(String) onChanged;
  final Function(String) onSelect;
  final Function()? onFetchGps;
  final Function()? onClearGps;

  const LocationField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isFromLocation,
    required this.suggestions,
    required this.isUsingCurrentLocation,
    required this.onChanged,
    required this.onSelect,
    this.onFetchGps,
    this.onClearGps,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              suffixIcon: isFromLocation
                  ? (isUsingCurrentLocation.value
                  ? IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onClearGps,
              )
                  : IconButton(
                icon:
                const Icon(Icons.gps_fixed, color: Colors.yellow),
                onPressed: onFetchGps,
              ))
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: onChanged,
          ),

          /// Suggestion Box
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
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      onSelect(suggestions[index]);
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
}
