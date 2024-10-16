import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void customBottomSheet(
    {required BuildContext context,
    required String firstText,
    required String secondText,
    required String buttonText,
    required VoidCallback ontap}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: 438.h,
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                softWrap: true,
                firstText,
                style: GoogleFonts.playfairDisplay(
                  color: GlobalColors.textblackBoldColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                secondText,
                textAlign: TextAlign.center,
                softWrap: true,
                style: GoogleFonts.openSans(
                  color: GlobalColors.textblackBoldColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 50.h),
              CustomButton(
                  onTap: ontap,
                  decorationColor: GlobalColors.kDeepPurple,
                  text: buttonText,
                  textColor: GlobalColors.textWhiteColor),
              SizedBox(
                height: 15.h,
              ),
              CustomButton(
                  onTap: () => Get.back(),
                  decorationColor: GlobalColors.textWhiteColor,
                  text: 'Cancel',
                  border: true,
                  textColor: GlobalColors.kDeepPurple),
            ],
          ),
        ),
      );
    },
  );
}
