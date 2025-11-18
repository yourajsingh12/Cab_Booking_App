import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../navigator.dart';


class SplashIntroScreen extends StatefulWidget {
  const SplashIntroScreen({Key? key}) : super(key: key);

  @override
  State<SplashIntroScreen> createState() => _SplashIntroScreenState();
}

class _SplashIntroScreenState extends State<SplashIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavigationMenu()),
    );
  }

  Widget buildFullImage(String path) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: "",
        body:
        "",
        image: buildFullImage("assets/images/onboarding1.jpg"),
        decoration: pageDecoration(),
      ),
      // PageViewModel(
      //    title: "",
      //    body:
      //   "",
      //   image: buildFullImage("assets/images/3.png"),
      //   decoration: pageDecoration(),
      // ),
      PageViewModel(
        title: "",
        body:
        "",
        image: buildFullImage("assets/images/onboarding2.jpg"),
        decoration: pageDecoration(),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/4.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          IntroductionScreen(
            key: introKey,
            pages: pages,
            showSkipButton: true,
            skip: const Text("Skip", style: TextStyle(color: Colors.red)),
            next: const Text("Next", style: TextStyle(color: Colors.blue)),
            done: const Text("Done", style: TextStyle(color: Colors.green)),
            onDone: _onIntroEnd,
            onSkip: _onIntroEnd,
            baseBtnStyle: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            dotsDecorator: DotsDecorator(
              activeColor: Colors.blue,
              size: const Size(10, 10),
              activeSize: const Size(22, 10),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            globalBackgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  PageDecoration pageDecoration() {
    return const PageDecoration(
      titlePadding: EdgeInsets.only(bottom: 30),
      bodyPadding: EdgeInsets.only(bottom: 80, left: 16, right: 16),
      pageColor: Colors.transparent,
      fullScreen: true,
      bodyFlex: 2,
      imageFlex: 3,
      bodyAlignment: Alignment.bottomCenter,
      bodyTextStyle: TextStyle(fontSize: 15, color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
