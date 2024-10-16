import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/auth_screen/create_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerifiedSuccess extends StatelessWidget {
  const EmailVerifiedSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 357.w,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/logo/checkmark.svg',
                  width: 100.w,
                  height: 100.h,
                ),
                SizedBox(height: 40.h),
                Text(
                  'Email Verified Successfully!',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.playfairDisplay(
                    color: GlobalColors.textblackBoldColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Your email and invite code have been verified. You are almost there—lets set up your password',
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
      )),
    );
  }
}
