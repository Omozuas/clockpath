import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String? clockInReminder;
  String? clockOutReminder;

  void proceed() {}

  // Function to check if both dropdowns are selected
  bool areBothDropdownsSelected() {
    return clockInReminder != null &&
        clockInReminder != 'Select time interval' &&
        clockOutReminder != null &&
        clockOutReminder != 'Select time interval';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.only(top: 10.h, bottom: 20.h, right: 20.w, left: 20.w),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset('assets/icons/backIcon.svg')),
                Flexible(
                  child: SizedBox(
                    width: 45.w,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Reminder Preferences',
                    style: GoogleFonts.playfairDisplay(
                      color: GlobalColors.textblackBoldColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Set your reminder preferences to get notified before clocking in and out',
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackSmallColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      thickness: 1,
                      color: GlobalColors.lightGrayeColor,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomDropdownField(
                      firstText: 'Clock In Reminder',
                      hintText: 'Select time interval',
                      items: const [
                        'Select time interval',
                        '5 minutes before',
                        '10 minutes before',
                        '15 minutes before',
                      ], // List of items in the dropdown
                      initialValue:
                          'Select time interval', // Initial selected value
                      onChanged: (value) {
                        setState(() {
                          clockInReminder = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomDropdownField(
                      firstText: 'Clock Out Reminder',
                      hintText: 'Select time interval',
                      items: const [
                        'Select time interval',
                        '5 minutes before',
                        '10 minutes before',
                        '15 minutes before',
                      ], // List of items in the dropdown
                      initialValue:
                          'Select time interval', // Initial selected value
                      onChanged: (value) {
                        setState(() {
                          clockOutReminder = value;
                        });
                      },
                    ),
                    SizedBox(height: 60.h),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                          onTap: () {},
                          decorationColor: GlobalColors.kDeepPurple,
                          text: 'Save Changes',
                          textColor: GlobalColors.textWhiteColor),
                    ),
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
