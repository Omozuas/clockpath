import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingShift extends ConsumerStatefulWidget {
  const UpcomingShift({super.key});

  @override
  ConsumerState<UpcomingShift> createState() => _UpcomingShiftState();
}

class _UpcomingShiftState extends ConsumerState<UpcomingShift> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => getWorkingDays());
  }

  void getWorkingDays() async {
    try {
      await ref.read(getWorkDaysProvider.notifier).getWorkDays();
      final res = ref.read(getWorkDaysProvider).value;
      if (res == null) return;
      if (res.status == "success") {
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
    ref.watch(setupProfileProvider).clockIn;
    ref.watch(setupProfileProvider).clockOut;
    ref.watch(getRequestProvider);
    ref.watch(getNotificationProvider);
    ref.watch(getRecentActivityProvider);
    final workDay = ref.watch(getWorkDaysProvider);
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
          child: SingleChildScrollView(
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
                      'Upcoming Shifts',
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
              workDay.when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                data: (work) {
                  final workDays = work?.data?.data?.workDays;

                  // Check if workDays is null or empty
                  if (workDays == null || workDays.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Set your upcoming shift",
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp, // Responsive font size
                          fontWeight: FontWeight.w600,
                          color: GlobalColors.textblackBoldColor,
                        ),
                      ),
                    );
                  }
                  // If workDays is not empty, render the ListView
                  return ListView.builder(
                    itemCount: workDays.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final workDay = workDays[index];
                      final startTime = workDay.shift?.start ?? '';
                      final endTime = workDay.shift?.end ?? '';
                      final date = workDay.date ?? '';

                      String shiftLabel = getShiftLabel(startTime);
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: 15.h), // Responsive padding
                        child: Container(
                          height: 113.h, // Responsive container height

                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.w, // Responsive border width
                              color: GlobalColors.lightGrayeColor,
                            ),
                            color: GlobalColors.backgroundColor2,
                            borderRadius: BorderRadius.circular(
                                16.r), // Responsive border radius
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 16.w), // Responsive padding
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 31.h, // Responsive height
                                      width: 109.w, // Responsive width
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                          horizontal:
                                              10.w), // Responsive padding
                                      decoration: BoxDecoration(
                                        color: GlobalColors.kLightpPurple,
                                        borderRadius: BorderRadius.circular(
                                            16.r), // Responsive border radius
                                      ),
                                      child: Center(
                                        child: Text(
                                          shiftLabel,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            color: GlobalColors.kDeepPurple,
                                            fontSize:
                                                12.sp, // Responsive font size
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 15.h), // Responsive spacing
                                    Text(
                                      date,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        color: GlobalColors.textblackBoldColor,
                                        fontSize: 14.sp, // Responsive font size
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                width: 1.w, // Responsive divider width
                                indent: 8.h, // Responsive indent
                                endIndent: 8.h, // Responsive end indent
                                color: GlobalColors.lightGrayeColor,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'START :',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackBoldColor
                                                  .withOpacity(0.5),
                                              fontSize:
                                                  16.sp, // Responsive font size
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 5
                                                  .w), // Responsive spacing between texts
                                          Text(
                                            startTime,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackSmallColor,
                                              fontSize:
                                                  14.sp, // Responsive font size
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 15.h), // Responsive spacing
                                      Row(
                                        children: [
                                          Text(
                                            'END :',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackBoldColor
                                                  .withOpacity(0.5),
                                              fontSize:
                                                  16.sp, // Responsive font size
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 5
                                                  .w), // Responsive spacing between texts
                                          Text(
                                            endTime,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackSmallColor,
                                              fontSize:
                                                  14.sp, // Responsive font size
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (e, s) {
                  return Text('$e,$s');
                },
                loading: () => Shimmer.fromColors(
                    baseColor: GlobalColors.kLightpPurple,
                    highlightColor: GlobalColors.kLightpPurple.withOpacity(0.1),
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 15.h), // Responsive padding
                          child: Container(
                            height: 113.h, // Responsive container height

                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.w, // Responsive border width
                                color: GlobalColors.lightGrayeColor,
                              ),
                              color: GlobalColors.backgroundColor2,
                              borderRadius: BorderRadius.circular(
                                  16.r), // Responsive border radius
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 16.w), // Responsive padding
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 31.h, // Responsive height
                                        width: 109.w, // Responsive width
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6.h,
                                            horizontal:
                                                10.w), // Responsive padding
                                        decoration: BoxDecoration(
                                          color: GlobalColors.kLightpPurple,
                                          borderRadius: BorderRadius.circular(
                                              16.r), // Responsive border radius
                                        ),
                                        child: Center(
                                          child: Text(
                                            '',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.kDeepPurple,
                                              fontSize:
                                                  12.sp, // Responsive font size
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.h), // Responsive spacing
                                      Text(
                                        'date',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          color:
                                              GlobalColors.textblackBoldColor,
                                          fontSize:
                                              14.sp, // Responsive font size
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  width: 1.w, // Responsive divider width
                                  indent: 8.h, // Responsive indent
                                  endIndent: 8.h, // Responsive end indent
                                  color: GlobalColors.lightGrayeColor,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'START :',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor
                                                    .withOpacity(0.5),
                                                fontSize: 16
                                                    .sp, // Responsive font size
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                                width: 5
                                                    .w), // Responsive spacing between texts
                                            Text(
                                              'startTime',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackSmallColor,
                                                fontSize: 14
                                                    .sp, // Responsive font size
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 15.h), // Responsive spacing
                                        Row(
                                          children: [
                                            Text(
                                              'END :',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor
                                                    .withOpacity(0.5),
                                                fontSize: 16
                                                    .sp, // Responsive font size
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                                width: 5
                                                    .w), // Responsive spacing between texts
                                            Text(
                                              'endTime',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackSmallColor,
                                                fontSize: 14
                                                    .sp, // Responsive font size
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }

  // Function to determine the shift label
  String getShiftLabel(String time) {
    if (time.isEmpty) return 'Unknown Shift';

    final parts = time.split(':');
    if (parts.length < 2) return 'Unknown Shift';

    final hour = int.tryParse(parts[0]) ?? 0;

    if (hour >= 6 && hour < 12) return 'Morning Shift';
    if (hour >= 12 && hour < 16) return 'Afternoon Shift';
    if (hour >= 16 && hour < 19) return 'Evening Shift';
    return 'Night Shift';
  }
}
