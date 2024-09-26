import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/auth_screen/create_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordSuccesScreen extends StatelessWidget {
  const PasswordSuccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 357.w,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/logo/checkmark.svg',
                        width: 100.w,
                        height: 100.h,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Password Set Successfully!',
                        style: GoogleFonts.playfairDisplay(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Your account is now secure. You are all set to log in and start using ClockPath',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackSmallColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            onTap: () {
                              Get.offAll(() => const CreatePasswordScreen());
                            },
                            decorationColor: GlobalColors.kDeepPurple,
                            text: 'Create Password',
                            textColor: GlobalColors.textWhiteColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
