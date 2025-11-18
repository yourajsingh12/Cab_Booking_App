import 'package:flutter/material.dart';
import '../../../../Res/constant/colors.dart';

class CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: UColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category['icon'], color: UColors.black, size: 32),
                ),
                const SizedBox(height: 5),
                Text(
                  category['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
