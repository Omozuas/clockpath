import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:clockpath/views/auth_screen/signup_screen.dart';
import 'package:clockpath/views/onboarding_screen/widgets/onboarding_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  Future<void> _checkTokenValidity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token != null) {
      // If the token exists and is not expired, navigate to MainScreen
      Get.offAll(() => const LoginScreen());
    } else {
      // If the token is missing or expired, navigate to OnboardingScreen
      Get.offAll(() => const SignupScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.6.sh, // Responsive height (50% of screen height)
              child: Center(
                child: PageView(
                  controller: _controller,
                  children: const [
                    OnboardingDetails(
                      imagAsset: 'assets/images/img1.png',
                      mainText: 'Welcome to ClockPath',
                      subText:
                          'Efficient time tracking and management made easy. Get started by setting up your work schedule and preferences',
                    ),
                    OnboardingDetails(
                      imagAsset: 'assets/images/img2.png',
                      mainText: 'Customize Your Work Week',
                      subText:
                          'Update your workdays and hours to match your schedule. We’ll help you stay organized and on track',
                    ),
                    OnboardingDetails(
                      imagAsset: 'assets/images/img3.png',
                      mainText: 'Stay On Time',
                      subText:
                          'Set your reminder preferences to get timely notifications for clocking in and out. Never miss a beat!',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: CustomizableEffect(
                  activeDotDecoration: DotDecoration(
                    width: 40.w,
                    height: 8.h,
                    color: GlobalColors.kDeepPurple,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  dotDecoration: DotDecoration(
                    width: 40.w,
                    height: 8.h,
                    color: GlobalColors.lightGrayeColor,
                    borderRadius: BorderRadius.circular(16.r),
                    verticalOffset: 0,
                  ),
                  spacing: 6.w, // Responsive spacing
                ),
              ),
            ),
            SizedBox(
              height: 75.h,
            ),
            CustomButton(
              onTap: _checkTokenValidity,
              text: 'Get Started',
              decorationColor: GlobalColors.kDeepPurple,
              textColor: GlobalColors.textWhiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
