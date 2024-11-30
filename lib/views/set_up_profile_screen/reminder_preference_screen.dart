import 'dart:developer';

import 'package:clockpath/apis/riverPod/settings_provider/settings_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:clockpath/views/set_up_profile_screen/location_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderPreferenceScreen extends ConsumerStatefulWidget {
  const ReminderPreferenceScreen({super.key});

  @override
  ConsumerState<ReminderPreferenceScreen> createState() =>
      _ReminderPreferenceScreenState();
}

class _ReminderPreferenceScreenState
    extends ConsumerState<ReminderPreferenceScreen> {
  String? clockInReminder;
  String? clockOutReminder;

// Function to check if both dropdowns are selected
  bool areBothDropdownsSelected() {
    return clockInReminder != null && clockOutReminder != null;
  }

  // Generate 24-hour formatted time intervals from 6:00 AM to 11:59 PM
  List<String> generateTimeIntervals() {
    List<String> intervals = [];
    for (int hour = 6; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 1) {
        final formattedTime =
            "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        intervals.add(formattedTime);
      }
    }
    return intervals;
  }

  void proceed() async {
    log(".....start");

    try {
      await ref.read(settingsProvider.notifier).reminder(
          clockInReminder: clockInReminder ?? '',
          clockOutReminder: clockOutReminder ?? '');
      final res = ref.read(settingsProvider).reminder.value;
      if (res == null) return;
      if (res.status == "success") {
        showSuccess(
          res.message,
        );
        Get.to(() => const LocationPermissionScreen());
      } else {
        log(res.message);
        showError(
          res.message,
        );
        if (res.message == 'Invalid or expired token. Please sign in again.') {
          Get.offAll(() => const LoginScreen());
        }
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate time intervals
    final timeIntervals = generateTimeIntervals();
    final isLoading = ref.watch(settingsProvider).reminder.isLoading;
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
                      items: timeIntervals, // List of items in the dropdown
                      initialValue: clockInReminder, // Initial selected value
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
                      items: timeIntervals,

                      initialValue: clockOutReminder, // Initial selected value
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
                        isLoading: isLoading,
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
