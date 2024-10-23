// ignore_for_file: file_names

import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.text,
      this.showBoder = false});
  final VoidCallback onTap;
  final String icon, text;
  final bool showBoder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
        decoration: BoxDecoration(
          border: Border(
              right: BorderSide.none,
              left: BorderSide.none,
              top: BorderSide.none,
              bottom: showBoder
                  ? BorderSide.none
                  : BorderSide(width: 1, color: GlobalColors.lightGrayeColor)),
          color: GlobalColors.textWhiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.openSans(
                    color: GlobalColors.textblackBoldColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/icons/arrowright.svg',
              height: 20.h,
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
