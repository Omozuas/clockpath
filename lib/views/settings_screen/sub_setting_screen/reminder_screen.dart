import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_reminder_provider/get_reminder_provider.dart';
import 'package:clockpath/apis/riverPod/settings_provider/settings_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  String? clockInReminder;
  String? clockOutReminder;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => getReminder());
  }

  void proceed() async {
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
        getReminder();
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

  void getReminder() async {
    log(".....start");

    try {
      await ref.read(getReminderProvider.notifier).getReminder();
      final res = ref.read(getReminderProvider).value;
      if (res == null) return;
      if (res.status == "success") {
        showSuccess(
          res.message,
        );

        clockInReminder = (res.data?.clockIn?.reminderTime ?? '')
            .replaceAll('AM', '')
            .replaceAll('PM', '')
            .trim();
        clockOutReminder = (res.data?.clockOut?.reminderTime ?? '')
            .replaceAll('AM', '')
            .replaceAll('PM', '')
            .trim();
      } else {
        log(res.message);
        showError(
          res.message,
        );
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  // Function to check if both dropdowns are selected
  bool areBothDropdownsSelected() {
    return clockInReminder != null && clockOutReminder != null;
  }

  // Generate 24-hour formatted time intervals from 6:00 AM to 11:59 PM
  List<String> generateTimeIntervals() {
    List<String> intervals = [];
    for (int hour = 6; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 10) {
        final formattedTime =
            "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        intervals.add(formattedTime);
      }
    }
    return intervals;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(settingsProvider).reminder.isLoading;
    ref.watch(getReminderProvider);
    final timeIntervals = generateTimeIntervals();

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
                      hintText: clockInReminder ?? 'Select time interval',
                      items: timeIntervals, // List of items in the dropdown
                      initialValue: clockInReminder, // Initial selected value
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
                      hintText: clockOutReminder ?? 'Select time interval',
                      items: timeIntervals, // List of items in the dropdown
                      initialValue: clockOutReminder, // Initial selected value
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
                          onTap: proceed,
                          isLoading: isLoading,
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
