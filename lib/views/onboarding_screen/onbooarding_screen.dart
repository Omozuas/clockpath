import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/auth_screen/signup_screen.dart';
import 'package:clockpath/views/onboarding_screen/widgets/onboarding_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbooardingScreen extends StatefulWidget {
  const OnbooardingScreen({super.key});

  @override
  State<OnbooardingScreen> createState() => _OnbooardingScreenState();
}

class _OnbooardingScreenState extends State<OnbooardingScreen> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15.0, left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 430.h,
              child: Center(
                child: PageView(
                  controller: _controller,
                  children: const [
                    OnboardingDetails(
                        imagAsset: 'assets/images/img1.png',
                        mainText: 'Welcome to ClockPath',
                        subText:
                            'Efficient time tracking and management made easy. Get started by setting up your work schedule and preferences'),
                    OnboardingDetails(
                        imagAsset: 'assets/images/img2.png',
                        mainText: 'Customize Your Work Week',
                        subText:
                            'Update your workdays and hours to match your schedule. We’ll help you stay organized and on track'),
                    OnboardingDetails(
                        imagAsset: 'assets/images/img3.png',
                        mainText: 'Stay On Time',
                        subText:
                            ' Set your reminder preferences to get timely notifications for clocking in and out. Never miss a beat!'),
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
                  spacing: 6.0,
                ),
              ),
            ),
            SizedBox(
              height: 75.h,
            ),
            CustomButton(
              onTap: () {
                Get.offAll(() => const SignupScreen());
              },
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
