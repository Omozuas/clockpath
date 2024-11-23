import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:clockpath/views/onboarding_screen/onbooarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      _checkTokenValidity();
    });
  }

  Future<void> _checkTokenValidity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token != null && JwtDecoder.isExpired(token) == false) {
      // If the token exists and is not expired, navigate to MainScreen
      Get.offAll(() => const MainScreen());
    } else {
      // If the token is missing or expired, navigate to OnboardingScreen
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.kDeepPurple,
      body: Center(
          child: SvgPicture.asset(
        'assets/logo/logo.svg',
        width: 279.w,
        height: 60.w,
      )),
    );
  }
}
