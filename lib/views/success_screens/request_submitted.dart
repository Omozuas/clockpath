import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestSubmitted extends StatefulWidget {
  const RequestSubmitted({super.key});

  @override
  State<RequestSubmitted> createState() => _RequestSubmittedState();
}

class _RequestSubmittedState extends State<RequestSubmitted> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
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
                  'Request Submitted',
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
                  'Your request has been sent to HR for approval. You will be notified when its processed',
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
                        Get.offAll(() => const MainScreen());
                        controller.mainIndex.value = 2;
                      },
                      decorationColor: GlobalColors.kDeepPurple,
                      text: 'View My Requests',
                      textColor: GlobalColors.textWhiteColor),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      onTap: () {
                        Get.offAll(() => const MainScreen());
                        controller.mainIndex.value = 0;
                      },
                      decorationColor: GlobalColors.textWhiteColor,
                      text: 'Return To Home',
                      border: true,
                      textColor: GlobalColors.kDeepPurple),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
