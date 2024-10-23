import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_listTile.dart';
import 'package:clockpath/common/custom_popup.dart';
import 'package:clockpath/views/settings_screen/sub_setting_screen/manage_password_screen.dart';
import 'package:clockpath/views/settings_screen/sub_setting_screen/manage_shift_screen.dart';
import 'package:clockpath/views/settings_screen/sub_setting_screen/profile_screen.dart';
import 'package:clockpath/views/settings_screen/sub_setting_screen/reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset('assets/icons/backIcon.svg')),
                Flexible(
                  child: SizedBox(
                    width: 110.w,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.openSans(
                      color: GlobalColors.textblackBoldColor,
                      fontSize: 18.sp,
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
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.h, right: 10.w, left: 10.w, bottom: 10.w),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: GlobalColors.lightGrayeColor),
                        color: GlobalColors.textWhiteColor,
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Column(
                      children: [
                        CustomListTile(
                          onTap: () => Get.to(() => const ProfileScreen()),
                          icon: 'assets/icons/useredit.svg',
                          text: 'Edit Profile',
                        ),
                        CustomListTile(
                          onTap: () =>
                              Get.to(() => const ManagePasswordScreen()),
                          icon: 'assets/icons/lock.svg',
                          text: 'Manage Passwords',
                        ),
                        CustomListTile(
                          onTap: () => Get.to(() => const ManageShiftScreen()),
                          icon: 'assets/logo/timer.svg',
                          text: 'Manage Shifts',
                        ),
                        CustomListTile(
                          onTap: () => Get.to(() => const ReminderScreen()),
                          icon: 'assets/logo/notification.svg',
                          text: 'Reminder Preferences',
                          showBoder: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    thickness: 1,
                    color: GlobalColors.lightGrayeColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () => showCustomPopup(
                        context: context,
                        boxh: 190.h,
                        boxw: 254.w,
                        decorationColor: GlobalColors.kDeepPurple,
                        firstText: 'LogOut From Your Account',
                        secondText: 'Are you sure you want to log out?',
                        proceed: () {}),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/logout.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text(
                          'LogOut',
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () => showCustomPopup(
                        context: context,
                        boxh: 226.h,
                        boxw: 335.w,
                        decorationColor: GlobalColors.deepred,
                        secondText:
                            'Are you sure you want to delete your account? This action is irreversible and all your data will be permanently lost',
                        proceed: () {}),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/trash.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text(
                          'Delete Account',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.deepred,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
