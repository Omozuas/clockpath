import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_bottomsheet.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/views/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
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
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: GlobalColors.lightGrayeColor,
                            ),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/icons/profile-circle.png')),
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
                              'John Doe',
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
                              color: GlobalColors.kDeepPurple.withOpacity(0.2),
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
                                    child: Center(
                                      child: Text(
                                        'Clocked Out',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          color: GlobalColors.kDeepPurple,
                                          fontSize:
                                              12.sp, // Responsive font size
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
                                    'Mon',
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
                                '17th Jun, 2025',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  color: GlobalColors.textWhiteColor,
                                  fontSize: 16.sp, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 20.h), // Responsive spacing
                              Text(
                                '09:00 AM',
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
                              color: GlobalColors.kYellowColor.withOpacity(0.2),
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
                ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
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
                                        horizontal: 10.w), // Responsive padding
                                    decoration: BoxDecoration(
                                      color: GlobalColors.kLightpPurple,
                                      borderRadius: BorderRadius.circular(
                                          16.r), // Responsive border radius
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Morning Shift',
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
                                  SizedBox(height: 15.h), // Responsive spacing
                                  Text(
                                    'Tue 18th Jun, 2025',
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
                                          '09:00 AM',
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
                                          '05:00 PM',
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
                ),
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
                      ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: GlobalColors.backgroundColor2,
                              ),
                              height: 37.h,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 0, top: 10.dg),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '17/05/2025',
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '09:00 AM',
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '05:00 PM',
                                              textAlign: TextAlign.end,
                                              softWrap: true,
                                              style: GoogleFonts.openSans(
                                                color: GlobalColors
                                                    .textblackBoldColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 1.h, // Responsive divider width
                                      indent: 30.h, // Responsive indent
                                      endIndent: 30.h, // Responsive end indent
                                      color: GlobalColors.lightGrayeColor,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              child: CustomButton(
                  onTap: () => customBottomSheet(
                      context: context,
                      firstText: 'Confirm Clock In',
                      secondText:
                          'Your clock-in time will be recorded as 08:58 AM. Are you ready to start your shift?',
                      buttonText: 'Confirm Clock In',
                      ontap: () {
                        Get.back();
                        customBottomSheet(
                            context: context,
                            firstText: 'Location Access Required',
                            secondText:
                                'You cant clock in without granting location access. Please enable location services to proceed with accurate time tracking',
                            buttonText: 'Enable Location',
                            ontap: () {
                              Get.back();
                              customBottomSheet(
                                  context: context,
                                  firstText: 'Far Away from Location',
                                  secondText:
                                      'You’re a bit too far from your shift’s location. Are you sure you want to proceed?',
                                  buttonText: 'Proceed',
                                  ontap: () {});
                            });
                      }),
                  decorationColor: GlobalColors.kDeepPurple,
                  text: 'Clock In',
                  textColor: GlobalColors.textWhiteColor),
            ),
          ),
        )
      ],
    );
  }
}
