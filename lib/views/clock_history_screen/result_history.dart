import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultHistory extends StatelessWidget {
  const ResultHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset('assets/icons/backIcon.svg')),
                Flexible(
                  child: SizedBox(
                    width: 110.w,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Result',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.openSans(
                      color: GlobalColors.textblackBoldColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: GlobalColors.lightBlueColor,
              ),
              height: 37.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Clock In',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Clock Out',
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: GlobalColors.backgroundColor2,
              ),
              height: 37.h,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0, top: 10.dg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              arguments['date'] ?? '',
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              arguments['clockInTime'] ?? '',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              arguments['clockOutTime'] ?? '-------------',
                              textAlign: TextAlign.end,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h, // Responsive divider width
                      indent: 23.h, // Responsive indent
                      endIndent: 23.h, // Responsive end indent
                      color: GlobalColors.lightGrayeColor,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
