import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManageShiftScreen extends ConsumerStatefulWidget {
  const ManageShiftScreen({super.key});

  @override
  ConsumerState<ManageShiftScreen> createState() => _ManageShiftScreenState();
}

class _ManageShiftScreenState extends ConsumerState<ManageShiftScreen> {
  List<Map<String, dynamic>> work = [];
  String mondayStart = '',
      tuesdayStart = '',
      wednessadyStart = '',
      thursdayStart = '',
      saturdayStart = '',
      sundayStart = '',
      fridayStart = '',
      mondayEnd = '',
      tuesdayEnd = '',
      wednessadyEnd = '',
      thursdayEnd = '',
      saturdayEnd = '',
      sundayEnd = '',
      fridayEnd = '';
  final Map<String, bool> _expandedTiles = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
    "ooo": false,
  };
  // Validate and Sign Up
  void proceed() async {
    log('start');
    work.clear();
    try {
      if (mondayStart.isNotEmpty && mondayEnd.isNotEmpty) {
        work.add({
          "day": "Monday",
          "shift": {"start": mondayStart, "end": mondayEnd}
        });
      }
      if (tuesdayStart.isNotEmpty && tuesdayEnd.isNotEmpty) {
        work.add({
          "day": "Tuesday",
          "shift": {"start": tuesdayStart, "end": tuesdayEnd}
        });
      }
      if (wednessadyStart.isNotEmpty && wednessadyEnd.isNotEmpty) {
        work.add({
          "day": "Wednesday",
          "shift": {"start": wednessadyStart, "end": wednessadyEnd}
        });
      }
      if (thursdayStart.isNotEmpty && thursdayEnd.isNotEmpty) {
        work.add({
          "day": "Thursday",
          "shift": {"start": thursdayStart, "end": thursdayEnd}
        });
      }
      if (fridayStart.isNotEmpty && fridayEnd.isNotEmpty) {
        work.add({
          "day": "Friday",
          "shift": {"start": fridayStart, "end": fridayEnd}
        });
      }
      if (saturdayStart.isNotEmpty && saturdayEnd.isNotEmpty) {
        work.add({
          "day": "Saturday",
          "shift": {"start": saturdayStart, "end": saturdayEnd}
        });
      }
      if (sundayStart.isNotEmpty && sundayEnd.isNotEmpty) {
        work.add({
          "day": "Sunday",
          "shift": {"start": sundayStart, "end": sundayEnd}
        });
      }
      await ref.read(setupProfileProvider.notifier).setupPWordDays(work: work);
      final res = ref.read(setupProfileProvider).setupWorkDays.value;
      if (res == null) return;
      if (res.status == 'success') {
        showSuccess(
          res.message,
        );
        // Get.to(() => const ReminderPreferenceScreen());
        work.clear();
      } else {
        log(res.message);
        showError(
          res.message,
        );
        work.clear();
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  // Generate the list of times from 6:00 AM to 12:00 AM

  List<String> generateTimeList() {
    List<String> timeList = [];
    DateTime startTime = DateTime(0, 1, 1, 6, 0); // Start at 06:00
    DateTime endTime = DateTime(0, 1, 1, 23, 59); // End at 23:59
    final DateFormat timeFormat = DateFormat("HH:mm"); // 24-hour format

    while (startTime.isBefore(endTime)) {
      timeList.add(timeFormat.format(startTime));
      startTime =
          startTime.add(const Duration(minutes: 30)); // Increment by 30 minutes
    }

    return timeList;
  }

  late List<String> timeOptions;
  @override
  void initState() {
    super.initState();
    timeOptions = generateTimeList(); // Generate the time options
    Future.microtask(() => getWorkingDays());
  }

  void getWorkingDays() async {
    try {
      await ref.read(getWorkDaysProvider.notifier).getWorkDays();
      final res = ref.read(getWorkDaysProvider).value;
      if (res == null) return;
      if (res.status == "success") {
        res.data?.data?.workDays?.forEach((workDay) {
          switch (workDay.day) {
            case 'Monday':
              mondayStart = workDay.shift?.start ?? '';
              mondayEnd = workDay.shift?.end ?? '';
              break;
            case 'Tuesday':
              tuesdayStart = workDay.shift?.start ?? '';
              tuesdayEnd = workDay.shift?.end ?? '';
              break;
            case 'Wednesday':
              wednessadyStart = workDay.shift?.start ?? '';
              wednessadyEnd = workDay.shift?.end ?? '';
              break;
            case 'Thursday':
              thursdayStart = workDay.shift?.start ?? '';
              thursdayEnd = workDay.shift?.end ?? '';
              break;
            case 'Friday':
              fridayStart = workDay.shift?.start ?? '';
              fridayEnd = workDay.shift?.end ?? '';
              break;
            case 'Saturday':
              saturdayStart = workDay.shift?.start ?? '';
              saturdayEnd = workDay.shift?.end ?? '';
              break;
            case 'Sunday':
              sundayStart = workDay.shift?.start ?? '';
              sundayEnd = workDay.shift?.end ?? '';
              break;
          }
        });
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
    final isLoading = ref.watch(setupProfileProvider).setupWorkDays.isLoading;
    ref.watch(getWorkDaysProvider);

    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w, top: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset('assets/icons/backIcon.svg')),
                  Flexible(
                    child: SizedBox(
                      width: 80.w,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Manage Shifts',
                      style: GoogleFonts.playfairDisplay(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Customize your shift times for each workday to match your schedule',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackSmallColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Monday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Monday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: mondayStart.isNotEmpty
                                              ? mondayStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            setState(() {
                                              mondayStart = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: mondayEnd.isNotEmpty
                                              ? mondayEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            setState(() {
                                              mondayEnd = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Monday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Tuesday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Tuesday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: tuesdayStart.isNotEmpty
                                              ? tuesdayStart
                                              : null,
                                          // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            tuesdayStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: tuesdayEnd.isNotEmpty
                                              ? tuesdayEnd
                                              : null,
                                          // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            tuesdayEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Tuesday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Wednesday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Wednesday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: wednessadyStart
                                                  .isNotEmpty
                                              ? wednessadyStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            wednessadyStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: wednessadyEnd.isNotEmpty
                                              ? wednessadyEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            wednessadyEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Wednesday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Thursday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Thursday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: thursdayStart.isNotEmpty
                                              ? thursdayStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            thursdayStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: thursdayEnd.isNotEmpty
                                              ? thursdayEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            thursdayEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Thursday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Friday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Friday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: fridayStart.isNotEmpty
                                              ? fridayStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            fridayStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: fridayEnd.isNotEmpty
                                              ? fridayEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            fridayEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Friday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Saturday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Saturday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: saturdayStart.isNotEmpty
                                              ? saturdayStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            saturdayStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: saturdayEnd.isNotEmpty
                                              ? saturdayEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            saturdayEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Saturday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        color: GlobalColors.lightBlueColor,
                        child: ExpansionTile(
                            trailing: Icon(
                              _expandedTiles["Sunday"] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                            leading: Text(
                              'Sunday',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Container(),
                            children: [
                              Container(
                                color: GlobalColors.textWhiteColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'Start Shift',
                                          hintText: 'Start Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: sundayStart.isNotEmpty
                                              ? sundayStart
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            sundayStart = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: 166.w,
                                        // height: 51.h,
                                        child: CustomDropdownField(
                                          firstText: 'End Shift',
                                          hintText: 'End Shift',
                                          items:
                                              timeOptions, // List of items in the dropdown
                                          initialValue: sundayEnd.isNotEmpty
                                              ? sundayEnd
                                              : null, // Initial selected value
                                          onChanged: (value) {
                                            log('Selected: $value');
                                            saturdayEnd = value!;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Update the state when expansion changes
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _expandedTiles["Sunday"] =
                                    expanded; // Toggle the expanded state
                              });
                            }),
                      ),
                      SizedBox(height: 40.h),
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
              ),
            ],
          ),
        ),
      )),
    );
  }
}
