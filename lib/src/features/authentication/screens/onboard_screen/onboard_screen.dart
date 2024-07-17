import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_constants.dart';
import '../welcome_screen/welcome_screen.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Why Settle?',
      body:
          'With Settle, you can make seamless, secure, and efficient cross border transactions across all African countries',
      image: Center(
        child: SvgPicture.asset(
          'assets/images/why_settle.svg',
          width: 350,
          height: 350,
        ),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: onboardcaptionsSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: onboardsubCaptions,
          color: Colors.black,
        ),
      ),
    ),
    PageViewModel(
        title: 'Fees Estimate',
        body: 'Take advantage of our low transaction fees when sending money.',
        image: Center(
          child: SvgPicture.asset(
            'assets/images/fees_estimate.svg',
            width: 350,
            height: 350,
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: onboardcaptionsSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: onboardsubCaptions,
            color: Colors.black,
          ),
        )),
    PageViewModel(
      title: 'Instant Payments',
      body: 'Send and receive money across Africa in a matter of minutes',
      image: Center(
        child: SvgPicture.asset(
          'assets/images/instant_payments.svg',
          width: 350,
          height: 350,
        ),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: onboardcaptionsSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: onboardsubCaptions,
          color: Colors.black,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: IntroductionScreen(
            globalBackgroundColor: Colors.white,
            pages: pages,
            dotsDecorator: const DotsDecorator(
              size: Size(15, 15),
              color: Color.fromARGB(255, 145, 145, 146),
              activeSize: Size.square(15),
              activeColor: Colors.black,
            ),
            showDoneButton: true,
            done: const Text(
              'Done',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            showSkipButton: true,
            skip: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            showNextButton: true,
            next: const Icon(
              Icons.arrow_forward,
              size: 25,
              color: Colors.black,
            ),
            onSkip: () => onDone(context),
            onDone: () => onDone(context),
            curve: Curves.bounceInOut,
          ),
        ),
      ),
    );
  }

  void onDone(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
}
