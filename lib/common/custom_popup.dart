import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomPopup(
    {required BuildContext context,
    required double boxh,
    required double boxw,
    String? firstText,
    required String secondText,
    required VoidCallback proceed,
    required Color decorationColor}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: GlobalColors.textWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: SizedBox(
          width: boxw,
          height: boxh,
          child: Padding(
            padding: EdgeInsets.only(
                top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (firstText != null)
                  Text(
                    firstText,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.openSans(
                      color: GlobalColors.textblackBoldColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  secondText,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.openSans(
                    color: GlobalColors.textblackSmallColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 141.w,
                      height: 38.h,
                      child: CustomButton(
                          onTap: proceed,
                          decorationColor: decorationColor,
                          text: 'proceed',
                          textColor: GlobalColors.textWhiteColor),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 141.w,
                      height: 38.h,
                      child: CustomButton(
                          onTap: () => Get.back(),
                          decorationColor: GlobalColors.textWhiteColor,
                          text: 'Cancel',
                          border: true,
                          textColor: GlobalColors.kDeepPurple),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
