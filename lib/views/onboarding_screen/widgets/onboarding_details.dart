import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingDetails extends StatelessWidget {
  const OnboardingDetails(
      {super.key,
      required this.imagAsset,
      required this.mainText,
      required this.subText});
  final String imagAsset, mainText, subText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagAsset,
          width: 314.w,
          height: 247.h,
        ),
        SizedBox(height: 20.h),
        Text(
          mainText,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: GlobalColors.textblackBoldColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          subText,
          textAlign: TextAlign.center,
          softWrap: true,
          style: GoogleFonts.openSans(
            color: GlobalColors.textblackBoldColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
