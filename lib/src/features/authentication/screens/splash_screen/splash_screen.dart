import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/app_constants.dart';
import '../login/login_screen.dart';
import '../onboard_screen/onboard_screen.dart';

class SplashScreenSaver extends StatefulWidget {
  const SplashScreenSaver({Key? key}) : super(key: key);

  @override
  State<SplashScreenSaver> createState() {
    return _SplashScreenSaverState();
  }
}

class _SplashScreenSaverState extends State<SplashScreenSaver> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // User has not logged in, navigate to OnboardScreen or WelcomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo/settle_logo.svg',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Settle',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: onboardcaptionsSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/logo/insolify.png',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
