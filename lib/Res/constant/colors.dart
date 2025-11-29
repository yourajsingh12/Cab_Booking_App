import 'package:flutter/material.dart';

class UColors {
  UColors._();
  
  static final LinearGradient primary = LinearGradient(
    colors: [Color(0xFFFBC02D), const Color(0xFFFFF9C4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color yellow = Color(0xFFFBC02D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black= Color(0xFF000000);

}
