import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/apis/riverPod/settings_provider/settings_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/success_screens/request_submitted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewRequest extends ConsumerStatefulWidget {
  const NewRequest({super.key});

  @override
  ConsumerState<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends ConsumerState<NewRequest> {
  final TextEditingController requestType = TextEditingController();
  final TextEditingController note = TextEditingController();
  String clockInReminder = '';
  String startTime = '';
  String stopTime = '';
  @override
  void initState() {
    super.initState();
    dateTimeOptions = generateDateTimeList(); // Generate the time options
    // Listen to changes in both TextEditingControllers
    requestType.addListener(() => setState(() => areBothDropdownsSelected()));
    note.addListener(() => setState(() => areBothDropdownsSelected()));
  }

  @override
  void dispose() {
    requestType.dispose();
    note.dispose();
    super.dispose();
  }

  // Generate list of date-time options from 6:00 AM today to the end of the year
  List<String> generateDateTimeList() {
    List<String> dateTimeList = [];
    DateTime startDateTime = DateTime.now().add(Duration(
      hours: 6 - DateTime.now().hour, // Set to the next 6:00 AM
      minutes: -DateTime.now().minute,
    ));
    DateTime endDateTime =
        DateTime(DateTime.now().year, 12, 31, 23, 59); // End at Dec 31, 23:59

    final DateFormat displayFormat =
        DateFormat("dd MMM yyyy HH:mm"); // Display format
    while (startDateTime.isBefore(endDateTime)) {
      dateTimeList.add(displayFormat
          .format(startDateTime)); // Display as "12 Nov 2024 09:00"
      startDateTime = startDateTime
          .add(const Duration(minutes: 30)); // Increment by 30 minutes
    }
    return dateTimeList;
  }

  late List<String> dateTimeOptions;

  bool areBothDropdownsSelected() {
    return clockInReminder.isNotEmpty &&
        clockInReminder != 'Select request type' &&
        startTime.isNotEmpty &&
        stopTime.isNotEmpty &&
        requestType.text.isNotEmpty &&
        note.text.isNotEmpty;
  }

// Helper to find the ISO string for the selected display time
  String? findISODateTime(String displayTime) {
    final displayFormat = DateFormat("dd MMM yyyy HH:mm");
    try {
      DateTime dateTime = displayFormat.parse(displayTime);
      return dateTime.toIso8601String(); // Convert to ISO 8601 format
    } catch (e) {
      log('Error parsing date: $e');
      return null;
    }
  }

  void proceed() async {
    try {
      await ref.read(settingsProvider.notifier).requestUser(
          requestType: requestType.text,
          reason: clockInReminder,
          note: note.text,
          startDate: startTime,
          endDate: stopTime);
      final res = ref.read(settingsProvider).requestUser.value;
      if (res == null) return;
      if (res.status == 'success') {
        log(res.message);
        showSuccess(
          res.message,
        );
        Get.offAll(() => const RequestSubmitted());
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(settingsProvider).requestUser.isLoading;
    ref.watch(getRequestProvider);
    ref.watch(getRecentActivityProvider);
    ref.watch(getWorkDaysProvider);
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset('assets/icons/close.svg'),
                  ),
                  SizedBox(width: 100.w),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'New Request',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select the type of request and specify the dates to submit your time off',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackSmallColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        color: GlobalColors.lightGrayeColor,
                        thickness: 1.h,
                      ),
                      SizedBox(height: 20.h),
                      CustomDropdownField(
                        firstText: 'Request Type',
                        hintText: 'Select request type',
                        items: const [
                          'Select request type',
                          'Vacation Leave',
                          'Sick Leave',
                          'Personal Leave',
                          'Work From Home',
                          'Bereavement Leave',
                          'Jury Duty',
                          'Parental Leave',
                          'Medical Appointment',
                          'Half-Day Leave',
                          'Compensatory Off',
                          'Training/Workshop',
                          'Business Travel',
                          'Public Holiday',
                        ], // List of items in the dropdown
                        initialValue:
                            'Select request type', // Initial selected value
                        onChanged: (value) {
                          setState(() {
                            clockInReminder = value!;
                            areBothDropdownsSelected();
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomDropdownField(
                              firstText: 'Start Date',
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 20.h),
                              items:
                                  dateTimeOptions, // List of items in the dropdown
                              initialValue: startTime.isNotEmpty
                                  ? startTime
                                  : null, // Initial selected value
                              onChanged: (value) {
                                setState(() {
                                  startTime = findISODateTime(value!)!;
                                  areBothDropdownsSelected();
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomDropdownField(
                              firstText: 'End Date',
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 20.h),
                              items:
                                  dateTimeOptions, // List of items in the dropdown
                              initialValue: stopTime.isNotEmpty
                                  ? stopTime
                                  : null, // Initial selected value
                              onChanged: (value) {
                                setState(() {
                                  stopTime = findISODateTime(value!)!;
                                  areBothDropdownsSelected();
                                });
                                log('Selected Stop Time (ISO 8601): $stopTime');
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFields(
                        controller: requestType,
                        firstText: 'Reason for Request',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Reason for Request';
                          }

                          return null;
                        },
                        hintText: 'Enter Reason for Request',
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFields(
                        controller: note,
                        firstText: 'Additional notes (optional)',
                        hintText: 'Enter Additional notes (optional)',
                        maxLength: 100,
                        maxLines: 6,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                          isLoading: isLoading,
                          onTap: areBothDropdownsSelected()
                              ? proceed
                              : () {
                                  log('Button is disabled');
                                },
                          decorationColor: areBothDropdownsSelected()
                              ? GlobalColors.kDeepPurple
                              : GlobalColors.kLightpPurple,
                          text: 'Submit Request',
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
        ),
      ),
    );
  }
}
