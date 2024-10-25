import 'dart:developer';

import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_dropdow.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/views/success_screens/request_submitted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NewRequest extends StatefulWidget {
  const NewRequest({super.key});

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  final TextEditingController requestType = TextEditingController();
  final TextEditingController note = TextEditingController();
  String? clockInReminder;
  String? clockOutReminder;
  String? clockInReminder1;
  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
    requestType.addListener(areBothDropdownsSelected);
    note.addListener(areBothDropdownsSelected);
  }

  @override
  void dispose() {
    requestType.dispose();
    note.dispose();
    super.dispose();
  }

  bool areBothDropdownsSelected() {
    return clockInReminder != null &&
        clockInReminder != 'Select request type' &&
        clockOutReminder != null &&
        clockOutReminder != 'Select Date' &&
        clockInReminder1 != null &&
        clockInReminder1 != 'Select Date' &&
        requestType.text.isNotEmpty &&
        note.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
                          '5 minutes before',
                          '10 minutes before',
                          '15 minutes before',
                        ], // List of items in the dropdown
                        initialValue:
                            'Select request type', // Initial selected value
                        onChanged: (value) {
                          setState(() {
                            clockInReminder = value;
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
                              items: const [
                                'Select Date',
                                '5 minutes before',
                                '10 minutes before',
                                '15 minutes before',
                              ], // List of items in the dropdown
                              initialValue:
                                  'Select Date', // Initial selected value
                              onChanged: (value) {
                                setState(() {
                                  clockOutReminder = value;
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
                              items: const [
                                'Select Date',
                                '5 minutes before',
                                '10 minutes before',
                                '15 minutes before',
                              ], // List of items in the dropdown
                              initialValue:
                                  'Select Date', // Initial selected value
                              onChanged: (value) {
                                setState(() {
                                  clockInReminder1 = value;
                                });
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
                          onTap: areBothDropdownsSelected()
                              ? () {
                                  Get.offAll(() => const RequestSubmitted());
                                }
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
