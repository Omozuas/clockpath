import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_bottomsheet.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
// import 'package:clockpath/common/custom_bottomsheet.dart';
// import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  double page = 30;
  bool loading = false;
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => getNotifications());
    _scrollController = ScrollController()
      ..addListener(() {
        // Trigger when the user scrolls to the bottom
        if (loading) return;
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            loading = true;
          });
          page = page + 10;
          ref
              .read(getNotificationProvider.notifier)
              .getNotification(limit: page);
          setState(() {
            loading = false;
          });
        }
      });
  }

  void getNotifications() async {
    log('...statr');
    try {
      await ref
          .read(getNotificationProvider.notifier)
          .getNotification(limit: page);
      final res = ref.read(getNotificationProvider).value;

      if (res == null) return;
      if (res.status == "success") {
      } else {
        log(res.message);
        showError(
          res.message,
        );
        log('...noo');
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  String timeAgo(String dateTime) {
    // Parse the given string into a DateTime object
    DateTime parsedDateTime = DateTime.parse(dateTime).toUtc();

    // Get the current time in UTC
    DateTime currentTime = DateTime.now().toUtc();

    // Calculate the time difference
    Duration difference = currentTime.difference(parsedDateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      // For longer durations, you could customize further (e.g., weeks, months)
      return DateFormat.yMMMd().format(parsedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    final notification = ref.watch(getNotificationProvider);
    ref.watch(getRequestProvider);
    ref.watch(getRecentActivityProvider);
    ref.watch(getWorkDaysProvider);
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
            child: notification.when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                data: (data) {
                  final notify = data?.data?.response?.notifications;
                  if (notify == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/manlogo.png',
                          width: 150.w,
                          height: 150.h,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'No Notifications Yet',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.playfairDisplay(
                            color: GlobalColors.textblackBoldColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Youre all caught up! Check back later for updates',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.textblackSmallColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                      itemCount: notify.length,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final request = notify[index];
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (request.requestType != null)
                                          Text(
                                            '‘${request.requestType}’',
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.kDeepPurple,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        if (request.requestType == null)
                                          Text(
                                            '‘${request.status}’',
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.kDeepPurple,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        Text(
                                          ' ${request.status}',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: GoogleFonts.openSans(
                                            color:
                                                GlobalColors.textblackBoldColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (request.createdAt != null)
                                      Text(
                                        timeAgo(request.createdAt.toString()),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: GoogleFonts.openSans(
                                          color:
                                              GlobalColors.textblackSmallColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    request.message ?? '',
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (request.type == 'request')
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
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                GlobalColors.kDeepPurple,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ),
                                // if (request['redirect'] == 'view history')
                                //   Align(
                                //     alignment: Alignment.bottomRight,
                                //     child: TextButton(
                                //         onPressed: () =>
                                //             controller.mainIndex.value = 1,
                                //         child: Text(
                                //           'View History',
                                //           textAlign: TextAlign.end,
                                //           softWrap: true,
                                //           style: GoogleFonts.openSans(
                                //             color: GlobalColors.kDeepPurple,
                                //             decoration:
                                //                 TextDecoration.underline,
                                //             decorationColor:
                                //                 GlobalColors.kDeepPurple,
                                //             fontSize: 14.sp,
                                //             fontWeight: FontWeight.w400,
                                //           ),
                                //         )),
                                //   ),

                                if (request.type == 'reminder' &&
                                    request.status == 'clockOut')
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                        onPressed: () => customBottomSheet(
                                            context: context,
                                            firstText: 'Confirm Clock Out',
                                            secondText:
                                                'Your clock-out time will be recorded as ${request.time}. Are you ready to end your shift?',
                                            buttonText: 'Confirm Clock Out',
                                            ontap: () {}),
                                        child: Text(
                                          'Clock Out Now',
                                          textAlign: TextAlign.end,
                                          softWrap: true,
                                          style: GoogleFonts.openSans(
                                            color: GlobalColors.kDeepPurple,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                GlobalColors.kDeepPurple,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ),
                                if (request.type == 'reminder' &&
                                    request.status == 'clockIn')
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                        onPressed: () => customBottomSheet(
                                            context: context,
                                            firstText: 'Confirm Clock In',
                                            secondText:
                                                'Your clock-In time will be recorded as ${request.time} . Are you ready to start your shift?',
                                            buttonText: 'Confirm Clock Out',
                                            ontap: () {}),
                                        child: Text(
                                          'Clock In Now',
                                          textAlign: TextAlign.end,
                                          softWrap: true,
                                          style: GoogleFonts.openSans(
                                            color: GlobalColors.kDeepPurple,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                GlobalColors.kDeepPurple,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  )
                              ],
                            ),
                          ),
                        );
                      });
                },
                error: (e, s) {
                  return Text('$e,$s');
                },
                loading: () => const Text('..loading')),
          )
        ],
      ),
    );
  }
}
