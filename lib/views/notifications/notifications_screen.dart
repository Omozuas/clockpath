import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_bottomsheet.dart';
import 'package:clockpath/common/custom_popup.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
// import 'package:clockpath/common/custom_bottomsheet.dart';
// import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  double page = 30;
  bool loading = false;
  bool isClockedIn = false;
  double? locationMessage;
  double? locationMessage1;
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
        if (res.message == 'Invalid or expired token. Please sign in again.') {
          Get.offAll(() => const LoginScreen());
        } else if (res.message == 'No Internet connection') {
          load();
        } else if (res.message == 'Request Timeout') {
          load1();
        }
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

  void clockIn({required double latitude, required double longitude}) async {
    try {
      await ref
          .read(setupProfileProvider.notifier)
          .clockIn(longitude: longitude, latitude: latitude);
      final res = ref.read(setupProfileProvider).clockIn.value;
      if (res == null) return;
      if (res.status == "success") {
        statusLocation(isThere: 'true');
        getstatusLocation();
        showSuccess(res.message);
      } else {
        log(res.message);
        if (mounted) {
          customBottomSheet(
              context: context,
              firstText: 'Far Away from Location',
              secondText: res.message,
              buttonText: 'Proceed',
              ontap: () {
                Get.back();
              });
        }
        statusLocation(isThere: 'false');
        getstatusLocation();
        showError(res.message);
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  void clockOut({required double latitude, required double longitude}) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      var did = preferences.getString('isclockin') ?? '';

      if (did == 'true') {
        await ref
            .read(setupProfileProvider.notifier)
            .clockOut(longitude: longitude, latitude: latitude);
        final res = ref.read(setupProfileProvider).clockOut.value;
        if (res == null) return;
        if (res.status == "success") {
          statusLocation(isThere: 'false');
          getstatusLocation();
          showSuccess(res.message);
        } else {
          log(res.message);
          if (mounted) {
            customBottomSheet(
                context: context,
                firstText: 'Far Away from Location',
                secondText: res.message,
                buttonText: 'Proceed',
                ontap: () {
                  Get.back();
                });
          }
          statusLocation(isThere: 'true');
          getstatusLocation();
        }
      } else {
        showError('failed to clocked out');
      }
    } catch (e) {
      log(e.toString());
      showError(
        e.toString(),
      );
    }
  }

  void statusLocation({required String isThere}) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('isclockin', isThere);
  }

  Future<String> getstatusLocation() async {
    final preferences = await SharedPreferences.getInstance();
    var did = preferences.getString('isclockin') ?? '';
    if (did == 'true') {
      setState(() {
        isClockedIn == true;
      });
    }
    return preferences.getString('isclockin') ?? '';
  }

  Future<void> _requestLocationPermission() async {
    // Check if location permissions are granted
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      // Request location permission
      if (mounted) {
        customBottomSheet(
            context: context,
            firstText: 'Location Access Required',
            secondText:
                'You cant clock in without granting location access. Please enable location services to proceed with accurate time tracking',
            buttonText: 'Enable Location',
            ontap: () async {
              Get.back();
              status = await Permission.locationWhenInUse.request();
            });
      }
    }

    if (status.isGranted) {
      // Permission granted, fetch the user's location
      await _getCurrentLocation();
    } else {
      // Permission denied, show a message
      showError('Location permission denied. Please allow access to continue.');
      // setState(() {
      //   _locationMessage =
      //       'Location permission denied. Please allow access to continue.';
      // });
    }
  }

  // Function to get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showWarnning(
          'Location services are disabled. Please enable them in the settings.');

      return;
    }

    // Check if app has location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showWarnning(
            'Location permission denied. Please allow access to continue.');

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showError(
          'Location permissions are permanently denied. Please enable them from settings.');

      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    // setState(() {
    //   _locationMessage =
    //       'Your location: Lat ${position.latitude}, Long ${position.longitude}';
    // });
    setState(() {
      locationMessage = position.latitude;
      locationMessage1 = position.longitude;
    });
    // Proceed to main screen after successful location fetch
    clockIn(
        latitude: position.latitude,
        longitude: position
            .longitude); // Navigate only after location is successfully fetched
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
                            // height: 120.h,
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
                                            ontap: () {
                                              clockOut(
                                                  latitude:
                                                      locationMessage ?? 0,
                                                  longitude:
                                                      locationMessage1 ?? 0);
                                            }),
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
                                            ontap: () {
                                              Get.back();
                                              _requestLocationPermission();
                                            }),
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
                  return Shimmer.fromColors(
                      baseColor: GlobalColors.kLightpPurple,
                      highlightColor:
                          GlobalColors.kLightpPurple.withOpacity(0.1),
                      child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 10.h,
                                  left: 10.w,
                                  right: 10.w,
                                  bottom: 10.w),
                              child: Container(
                                // height: 120.h,
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide.none,
                                        left: BorderSide.none,
                                        right: BorderSide.none,
                                        bottom: BorderSide(
                                            width: 1,
                                            color:
                                                GlobalColors.lightGrayeColor))),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '‘request.requestType’',
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors.kDeepPurple,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '‘request.status’',
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors.kDeepPurple,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              'request.status',
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          ' 5min',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: GoogleFonts.openSans(
                                            color: GlobalColors
                                                .textblackSmallColor,
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
                                        'request.message',
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: GoogleFonts.openSans(
                                          color:
                                              GlobalColors.textblackBoldColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
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
                                  ],
                                ),
                              ),
                            );
                          }));
                },
                loading: () => Shimmer.fromColors(
                    baseColor: GlobalColors.kLightpPurple,
                    highlightColor: GlobalColors.kLightpPurple.withOpacity(0.1),
                    child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 10.h,
                                left: 10.w,
                                right: 10.w,
                                bottom: 10.w),
                            child: Container(
                              // height: 120.h,
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide.none,
                                      left: BorderSide.none,
                                      right: BorderSide.none,
                                      bottom: BorderSide(
                                          width: 1,
                                          color:
                                              GlobalColors.lightGrayeColor))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '‘request.requestType’',
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.kDeepPurple,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '‘request.status’',
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.kDeepPurple,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'request.status',
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackBoldColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        ' 5min',
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
                                      'request.message',
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: GoogleFonts.openSans(
                                        color: GlobalColors.textblackBoldColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
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
                                ],
                              ),
                            ),
                          );
                        }))),
          )
        ],
      ),
    );
  }

  void load() {
    showCustomPopup(
        context: context,
        boxh: 220.h,
        boxw: 254.w,
        decorationColor: GlobalColors.kDeepPurple,
        firstText: 'No Internet connection',
        secondText: 'Reload',
        proceed: () {
          Get.back();
          reloade();
        });
  }

  void load1() {
    showCustomPopup(
        context: context,
        boxh: 220.h,
        boxw: 254.w,
        decorationColor: GlobalColors.kDeepPurple,
        firstText: 'Request Timeout',
        secondText: 'Reload',
        proceed: () {
          Get.back();
          reloade();
        });
  }

  void reloade() {
    getNotifications();
  }
}
