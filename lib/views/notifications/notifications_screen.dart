import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_bottomsheet.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> requests = [
    {'type': 'sick leave', 'status': 'approved', 'redirect': 'view request'},
    {'type': 'Holiday', 'status': 'Pending', 'redirect': 'view history'},
    {'type': 'Half-Day', 'status': 'Rejected', 'redirect': 'clock out now'},
    {'type': 'clock out', 'status': 'Recorded', 'redirect': 'clock out now'},
    {'type': 'clock in', 'status': 'reminder', 'redirect': 'clock out now'},
    {'type': 'clock out', 'status': 'approved', 'redirect': 'clock out now'},
    {'type': 'clock in', 'status': 'approved', 'redirect': 'clock out now'},
    {'type': 'clock out', 'status': 'approved', 'redirect': 'clock out now'},
    {'type': 'clock out', 'status': 'approved', 'redirect': 'clock out now'},
  ];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Notifications',
              textAlign: TextAlign.center,
              softWrap: true,
              style: GoogleFonts.openSans(
                color: GlobalColors.textblackBoldColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h), // Added spacing
          Expanded(
            child: ListView.builder(
                itemCount: requests.length,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, left: 10.w, right: 10.w, bottom: 10.w),
                    child: Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide.none,
                              left: BorderSide.none,
                              right: BorderSide.none,
                              bottom: BorderSide(
                                  width: 1,
                                  color: GlobalColors.lightGrayeColor))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '‘${request['type']}’',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.kDeepPurple,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    ' ${request['status']}',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '10 mins ago',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: GoogleFonts.openSans(
                                  color: GlobalColors.textblackSmallColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Your sick leave request from Sept 2 to Sept 4 has been approved',
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: GoogleFonts.openSans(
                              color: GlobalColors.textblackBoldColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (request['redirect'] == 'view request')
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () =>
                                      controller.mainIndex.value = 2,
                                  child: Text(
                                    'View Request',
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.kDeepPurple,
                                      decoration: TextDecoration.underline,
                                      decorationColor: GlobalColors.kDeepPurple,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ),
                          if (request['redirect'] == 'view history')
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () =>
                                      controller.mainIndex.value = 1,
                                  child: Text(
                                    'View History',
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.kDeepPurple,
                                      decoration: TextDecoration.underline,
                                      decorationColor: GlobalColors.kDeepPurple,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ),
                          if (request['redirect'] == 'clock out now')
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () => customBottomSheet(
                                      context: context,
                                      firstText: 'Confirm Clock Out',
                                      secondText:
                                          'Your clock-out time will be recorded as 05:04 PM. Are you ready to end your shift?',
                                      buttonText: 'Confirm Clock Out',
                                      ontap: () {}),
                                  child: Text(
                                    'Clock Out Now',
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.kDeepPurple,
                                      decoration: TextDecoration.underline,
                                      decorationColor: GlobalColors.kDeepPurple,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
