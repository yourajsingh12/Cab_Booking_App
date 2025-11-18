import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerSlider extends StatelessWidget {
  final List<String> banners;
  final ValueChanged<int> onChanged;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1,
          onPageChanged: (index, reason) => onChanged(index),
        ),
        items: banners.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
          );
        }).toList(),
      ),
    );
  }
}
