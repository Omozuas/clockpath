import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  String? _locationMessage;

  // Function to request location permission and get the user's location
  Future<void> _requestLocationPermission() async {
    // Check if location permissions are granted
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      // Request location permission
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      // Permission granted, fetch the user's location
      await _getCurrentLocation();
    } else {
      // Permission denied, show a message
      setState(() {
        _locationMessage =
            'Location permission denied. Please allow access to continue.';
      });
    }
  }

  // Function to get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        _locationMessage =
            'Location services are disabled. Please enable them in the settings.';
      });
      return;
    }

    // Check if app has location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage =
              'Location permission denied. Please allow access to continue.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            'Location permissions are permanently denied. Please enable them from settings.';
      });
      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _locationMessage =
          'Your location: Lat ${position.latitude}, Long ${position.longitude}';
    });

    // Proceed to main screen after successful location fetch
    proceed(); // Navigate only after location is successfully fetched
  }

  // Navigate to MainScreen
  void proceed() {
    Get.offAll(() => const MainScreen());
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
        actions: [
          GestureDetector(
            onTap: () {
              // Direct navigation on 'Skip'
              proceed();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Skip',
                softWrap: true,
                style: GoogleFonts.openSans(
                  color: GlobalColors.kDeepPurple,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/giril2.png',
                height: 200.h,
                width: 200.w,
              ),
              Text(
                'Allow Location Access',
                style: GoogleFonts.playfairDisplay(
                  color: GlobalColors.textblackBoldColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'To ensure accurate time tracking and seamless clock-ins, please enable location services',
                textAlign: TextAlign.center,
                softWrap: true,
                style: GoogleFonts.openSans(
                  color: GlobalColors.textblackSmallColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              if (_locationMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _locationMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 40.h),

              // Conditionally show the button if both dropdowns are selected

              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 171.w,
                        child: CustomButton(
                            onTap: () {
                              // Optionally skip without checking location
                              proceed();
                            },
                            decorationColor: GlobalColors.textWhiteColor,
                            text: 'Not Now',
                            border: true,
                            textColor: GlobalColors.kDeepPurple),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 171.w,
                        child: CustomButton(
                            onTap: _requestLocationPermission,
                            decorationColor: GlobalColors.kDeepPurple,
                            text: 'Allow',
                            textColor: GlobalColors.textWhiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
