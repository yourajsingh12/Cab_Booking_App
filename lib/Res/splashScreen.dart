import 'dart:async';
import 'package:flutter/material.dart';
import '../navigator.dart';

class SplashIntroScreen extends StatefulWidget {
  const SplashIntroScreen({Key? key}) : super(key: key);

  @override
  State<SplashIntroScreen> createState() => _SplashIntroScreenState();
}

class _SplashIntroScreenState extends State<SplashIntroScreen> {

  @override
  void initState() {
    super.initState();


    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationMenu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
