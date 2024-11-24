import 'dart:async';
import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_bottomsheet.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:clockpath/views/settings_screen/settings_screen.dart';
import 'package:clockpath/views/settings_screen/sub_setting_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentTime1 = DateFormat('h:mm a').format(DateTime.now());
  double? locationMessage;
  double? locationMessage1;
  bool isClockedIn = false;
  late Timer timer;
  String networkImg = '', fullName = '';
  @override
  void initState() {
    super.initState();
    getDate();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      setState(() {
        currentTime1 = DateFormat('h:mm a').format(DateTime.now());
      });
    });
    getstatusLocation();
    getImge();
    Future.microtask(() => getRecentResults());
    // Future.microtask(() => getWorkingDays());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String day = '', formattedDate1 = '', currentTime = '';
  void getDate() {
    DateTime now = DateTime.now();

    // Format current date as '17th June 2023'
    String formattedDate = DateFormat("d'th' MMM yyyy").format(now);

    // Current day of the week
    String dayOfWeek = DateFormat('E').format(now);

    // Current time in 12-hour format with AM/PM
    String formattedTime = DateFormat('h:mm a').format(now);
    setState(() {
      day = dayOfWeek;
      formattedDate1 = formattedDate;
      currentTime = formattedTime;
    });
    log("Current Date: $formattedDate");
    log("Day of the Week: $dayOfWeek");
    log("Current Time: $formattedTime");
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

  // Function to request location permission and get the user's location
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
      showError(
          'Location services are disabled. Please enable them in the settings.');

      return;
    }

    // Check if app has location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError(
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

  void statusLocation({required String isThere}) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('isclockin', isThere);
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
    final recentAct = ref.watch(getRecentActivityProvider);
    final workDay = ref.watch(getWorkDaysProvider);
    final controller = Get.put(MainController());
    return Stack(
      children: [
        SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 80.h),
          child: RefreshIndicator(
            onRefresh: () async {},
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => const ProfileScreen()),
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: GlobalColors.lightGrayeColor,
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: networkImg.isEmpty
                                        ? const AssetImage(
                                            'assets/icons/profile-circle.png')
                                        : NetworkImage(networkImg)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: GoogleFonts.openSans(
                                  color: GlobalColors.kDeepPurple,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                fullName,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: GoogleFonts.openSans(
                                  color: GlobalColors.kDeepPurple,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const SettingsScreen()),
                        child: SvgPicture.asset(
                          'assets/icons/settings.svg',
                          width: 32.w,
                          height: 32.h,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(10.h), // Responsive padding
                          height: 170.h, // Responsive height
                          width: 171.w, // Responsive width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                16.r), // Responsive border radius
                            color: GlobalColors.kDeepPurple,
                            border: Border.all(
                                color: GlobalColors.textWhiteColor, width: 0.9),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    GlobalColors.kDeepPurple.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0.4.h,
                                bottom: 0.4.h,
                                right: 0.4.w,
                                left: 0.4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20.h, // Responsive height
                                      width: 83.w, // Responsive width
                                      decoration: BoxDecoration(
                                        color: GlobalColors.textWhiteColor,
                                        borderRadius: BorderRadius.circular(
                                            16.r), // Responsive border radius
                                      ),
                                      child: isClockedIn == true
                                          ? Center(
                                              child: Text(
                                                'Clocked Out',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  color:
                                                      GlobalColors.kDeepPurple,
                                                  fontSize: 12
                                                      .sp, // Responsive font size
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'Clocked In',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  color:
                                                      GlobalColors.kDeepPurple,
                                                  fontSize: 12
                                                      .sp, // Responsive font size
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        color: GlobalColors.textWhiteColor,
                                        fontSize: (16.sp).clamp(12.sp,
                                            16.sp), // Clamped responsive font size
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.h), // Responsive spacing
                                Text(
                                  formattedDate1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: GlobalColors.textWhiteColor,
                                    fontSize: 16.sp, // Responsive font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 20.h), // Responsive spacing
                                Text(
                                  currentTime1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: GlobalColors.textWhiteColor,
                                    fontSize: (24.sp).clamp(16.sp,
                                        24.sp), // Clamped responsive font size
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 10.w), // Responsive spacing between the cards
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(10.h), // Responsive padding
                          height: 170.h, // Responsive height
                          width: 171.w, // Responsive width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                16.r), // Responsive border radius
                            color: GlobalColors.kYellowColor,
                            border: Border.all(
                                color: GlobalColors.textWhiteColor, width: 0.9),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    GlobalColors.kYellowColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 2.h, bottom: 2.h, right: 2.w, left: 2.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Text(
                                  'Hours Left',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: GlobalColors.textblackBoldColor,
                                    fontSize: 18.sp, // Responsive font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 20.h), // Responsive spacing
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '----',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            color:
                                                GlobalColors.textblackBoldColor,
                                            fontSize:
                                                18.sp, // Responsive font size
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height: 20.h), // Responsive spacing
                                        Text(
                                          'Hrs',
                                          style: GoogleFonts.openSans(
                                            color:
                                                GlobalColors.textblackBoldColor,
                                            fontSize:
                                                24.sp, // Responsive font size
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width: 20
                                            .w), // Responsive spacing between columns
                                    Column(
                                      children: [
                                        Text(
                                          '----',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            color:
                                                GlobalColors.textblackBoldColor,
                                            fontSize:
                                                18.sp, // Responsive font size
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height: 20.h), // Responsive spacing
                                        Text(
                                          'Min',
                                          style: GoogleFonts.openSans(
                                            color:
                                                GlobalColors.textblackBoldColor,
                                            fontSize:
                                                24.sp, // Responsive font size
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Shifts',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'See All',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.kDeepPurple,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  workDay.when(
                      skipLoadingOnRefresh: true,
                      skipLoadingOnReload: true,
                      data: (work) {
                        final workDays = work?.data?.data?.workDays;

                        // Check if workDays is null or empty
                        if (workDays == null || workDays.isEmpty) {
                          return Center(
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
                          itemCount: 3,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                shiftLabel,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  color:
                                                      GlobalColors.kDeepPurple,
                                                  fontSize: 12
                                                      .sp, // Responsive font size
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  15.h), // Responsive spacing
                                          Text(
                                            date,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors
                                                  .textblackBoldColor,
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
                                                  startTime,
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
                                                height:
                                                    15.h), // Responsive spacing
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
                                                  endTime,
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
                        );
                      },
                      error: (e, s) {
                        return Text('$e,$s');
                      },
                      loading: () => const Text('..loading')),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.mainIndex.value = 1,
                        child: Text(
                          'See All',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.kDeepPurple,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 368.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.w, // Responsive border width
                        color: GlobalColors.lightGrayeColor,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: GlobalColors.lightBlueColor,
                          ),
                          height: 37.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date',
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Clock In',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Clock Out',
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        recentAct.when(
                            skipLoadingOnReload: true,
                            skipLoadingOnRefresh: true,
                            data: (data) {
                              var info = data?.data?.results;
                              if (info == null) {
                                return SizedBox(
                                  height: 180.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No Clock History Yet',
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: GoogleFonts.openSans(
                                          color:
                                              GlobalColors.textblackBoldColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'You havent clocked in yet. Start your first shift to see your work hours here',
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: GoogleFonts.openSans(
                                          color:
                                              GlobalColors.textblackSmallColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                  itemCount: info.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final item = info[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: GlobalColors.backgroundColor2,
                                      ),
                                      height: 37.h,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 0, top: 10.dg),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.w, right: 20.w),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.date ?? '',
                                                      textAlign:
                                                          TextAlign.start,
                                                      softWrap: true,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: GlobalColors
                                                            .textblackBoldColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      item.clockInTime ?? '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: GlobalColors
                                                            .textblackBoldColor,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      item.clockOutTime ??
                                                          '-------------',
                                                      textAlign: TextAlign.end,
                                                      softWrap: true,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: GlobalColors
                                                            .textblackBoldColor,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1
                                                  .h, // Responsive divider width
                                              indent: 30.h, // Responsive indent
                                              endIndent:
                                                  30.h, // Responsive end indent
                                              color:
                                                  GlobalColors.lightGrayeColor,
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

                        // ListView.builder(
                        //     itemCount: 10,
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.vertical,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //           color: GlobalColors.backgroundColor2,
                        //         ),
                        //         height: 37.h,
                        //         child: Padding(
                        //           padding: EdgeInsets.only(bottom: 0, top: 10.dg),
                        //           child: Column(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             children: [
                        //               Padding(
                        //                 padding: EdgeInsets.only(
                        //                     left: 20.w, right: 20.w),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Text(
                        //                         '17/05/2025',
                        //                         textAlign: TextAlign.start,
                        //                         softWrap: true,
                        //                         style: GoogleFonts.openSans(
                        //                           color: GlobalColors
                        //                               .textblackBoldColor,
                        //                           fontSize: 12.sp,
                        //                           fontWeight: FontWeight.w400,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     Expanded(
                        //                       child: Text(
                        //                         '09:00 AM',
                        //                         textAlign: TextAlign.center,
                        //                         softWrap: true,
                        //                         style: GoogleFonts.openSans(
                        //                           color: GlobalColors
                        //                               .textblackBoldColor,
                        //                           fontSize: 14.sp,
                        //                           fontWeight: FontWeight.w400,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     Expanded(
                        //                       child: Text(
                        //                         '05:00 PM',
                        //                         textAlign: TextAlign.end,
                        //                         softWrap: true,
                        //                         style: GoogleFonts.openSans(
                        //                           color: GlobalColors
                        //                               .textblackBoldColor,
                        //                           fontSize: 14.sp,
                        //                           fontWeight: FontWeight.w400,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Divider(
                        //                 height: 1.h, // Responsive divider width
                        //                 indent: 30.h, // Responsive indent
                        //                 endIndent: 30.h, // Responsive end indent
                        //                 color: GlobalColors.lightGrayeColor,
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 10),
              child: isClockedIn == false
                  ? CustomButton(
                      onTap: () => customBottomSheet(
                          context: context,
                          firstText: 'Confirm Clock In',
                          secondText:
                              'Your clock-in time will be recorded as $currentTime1. Are you ready to start your shift?',
                          buttonText: 'Confirm Clock In',
                          ontap: () {
                            Get.back();
                            _requestLocationPermission();
                          }),
                      decorationColor: GlobalColors.kDeepPurple,
                      text: 'Clock In',
                      textColor: GlobalColors.textWhiteColor)
                  : CustomButton(
                      onTap: () => customBottomSheet(
                          context: context,
                          firstText: 'Confirm Clock Out',
                          secondText:
                              'Your clock-in time will be recorded as $currentTime1. Are you ready to start your shift?',
                          buttonText: 'Confirm Clock Out',
                          ontap: () {
                            clockOut(
                                latitude: locationMessage ?? 0,
                                longitude: locationMessage1 ?? 0);
                          }),
                      decorationColor: GlobalColors.kDeepPurple,
                      text: 'Clock Out',
                      textColor: GlobalColors.textWhiteColor),
            ),
          ),
        )
      ],
    );
  }

  void getImge() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      networkImg = preferences.getString('image') ?? '';
      fullName = preferences.getString('name') ?? '';
    });
  }

  Future<void> getRecentResults() async {
    log('showerr......');
    await ref.read(getRecentActivityProvider.notifier).getRecentResults();
    final res = ref.read(getRecentActivityProvider).value;
    log('showerr..1${res?.message}');
    if (res == null) return;

    if (res.status != 'success') {
      showError(res.message);
      log('showerr..2${res.message}');
      return;
    }
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
