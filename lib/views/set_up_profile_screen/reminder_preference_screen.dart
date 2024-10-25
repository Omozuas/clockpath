import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:clockpath/views/set_up_profile_screen/location_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderPreferenceScreen extends StatefulWidget {
  const ReminderPreferenceScreen({super.key});

  @override
  State<ReminderPreferenceScreen> createState() =>
      _ReminderPreferenceScreenState();
}

class _ReminderPreferenceScreenState extends State<ReminderPreferenceScreen> {
  String? clockInReminder;
  String? clockOutReminder;

  void proceed() {
    Get.to(() => const LocationPermissionScreen());
  }

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
            EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w, top: 20.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Icon(Icons.arrow_back_ios,
                      color: GlobalColors.textblackBoldColor),
                  onTap: () {
                    Get.back();
                  },
                ),
                GestureDetector(
                  onTap: () => Get.offAll(() => const MainScreen()),
                  child: Text(
                    'Skip',
                    softWrap: true,
                    style: GoogleFonts.openSans(
                      color: GlobalColors.kDeepPurple,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Reminder Preferences',
                      style: GoogleFonts.playfairDisplay(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Set your reminder preferences to get notified before clocking in and out',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackSmallColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.h),
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
                      height: 30.h,
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
                    SizedBox(height: 40.h),

                    // Conditionally show the button if both dropdowns are selected

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        onTap: areBothDropdownsSelected() ? proceed : () {},
                        decorationColor: areBothDropdownsSelected()
                            ? GlobalColors.kDeepPurple
                            : GlobalColors.kLightpPurple,
                        text: 'Save and Continue',
                        textColor: areBothDropdownsSelected()
                            ? GlobalColors.textWhiteColor
                            : GlobalColors.kDLightpPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
