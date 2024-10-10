import 'dart:developer';

import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/views/set_up_profile_screen/reminder_preference_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkingDaysScreen extends StatefulWidget {
  const WorkingDaysScreen({super.key});

  @override
  State<WorkingDaysScreen> createState() => _WorkingDaysScreenState();
}

class _WorkingDaysScreenState extends State<WorkingDaysScreen> {
  bool _isExpanded = false;
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
  // Validate and Sign Up
  void proceed() {
    Get.to(() => const ReminderPreferenceScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.textWhiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: GlobalColors.textblackBoldColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Work Days',
                  style: GoogleFonts.playfairDisplay(
                    color: GlobalColors.textblackBoldColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Review and confirm your shift times for each workday to ensure accurate time tracking',
                  textAlign: TextAlign.center,
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
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 10.h),
                Container(
                  color: GlobalColors.lightBlueColor,
                  child: ExpansionTile(
                      trailing: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 166.w,
                                  // height: 51.h,
                                  child: CustomDropdownField(
                                    firstText: 'Start Shift',
                                    hintText: 'Start Shift',
                                    items: const [
                                      '08:00 AM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '08:00 AM', // Initial selected value
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
                                    items: const [
                                      '05:00 PM',
                                      'Manager',
                                      'User'
                                    ], // List of items in the dropdown
                                    initialValue:
                                        '05:00 PM', // Initial selected value
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
                          _isExpanded = expanded; // Toggle the expanded state
                        });
                      }),
                ),
                SizedBox(height: 40.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      onTap: proceed,
                      decorationColor: GlobalColors.kDeepPurple,
                      text: 'Save and Continue',
                      textColor: GlobalColors.textWhiteColor),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
