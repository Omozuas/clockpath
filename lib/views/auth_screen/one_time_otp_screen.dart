import 'dart:developer';

import 'package:clockpath/apis/riverPod/auth_flow/auth_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:clockpath/views/auth_screen/set_new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OneTimeOtpScreen extends ConsumerStatefulWidget {
  const OneTimeOtpScreen({super.key});

  @override
  ConsumerState<OneTimeOtpScreen> createState() => _OneTimeOtpScreenState();
}

class _OneTimeOtpScreenState extends ConsumerState<OneTimeOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Validate and Sign Up
  void proceed() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authProvider.notifier).oneTimePin(otp: otp);
        final res = ref.read(authProvider).oneTimePin.value;
        if (res == null) return;
        if (res.status == "success") {
          showSuccess(
            res.message,
          );
          Get.offAll(() => const SetNewPassword());
        } else {
          log(res.message);
          showError(
            res.message,
          );
        }
      } catch (e) {
        log(e.toString());
        showError(
          e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).oneTimePin.isLoading;
    final isLoading1 = ref.watch(authProvider).forgotPassword.isLoading;
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/logo/mainlogo.svg',
                        width: 56.w,
                        height: 56.h,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Enter One-Time Password (OTP)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'We have sent a 6-digit OTP to your email. Please enter it below to verify your account',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50.w,
                        child: CustomTextFields(
                          contentPadding: EdgeInsets.only(
                              top: 10.h, bottom: 10.h, left: 15.w, right: 15.w),
                          firstText: '',
                          autofocus: index == 0,
                          controller: _otpControllers[index],
                          hintText: "",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '•';
                            }
                            if (value.length != 1 ||
                                !RegExp(r'\d').hasMatch(value)) {
                              return '!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.length == 1 && index < 6) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 50.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        CustomButton(
                            onTap: proceed,
                            decorationColor: GlobalColors.kDeepPurple,
                            isLoading: isLoading,
                            text: 'Verify OTP',
                            textColor: GlobalColors.textWhiteColor),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn’t receive any code? ',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackSmallColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: isLoading1 ? () {} : resend,
                              child: Text(
                                isLoading1 ? 'loading...' : 'Resend',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: GoogleFonts.openSans(
                                  color: GlobalColors.kDeepPurple,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resend() async {
    log(".....start");
    final arguments = Get.arguments;
    final email = arguments['email'] ?? '';

    try {
      await ref.read(authProvider.notifier).forgotPassword(
            email: email,
          );
      final res = ref.read(authProvider).forgotPassword.value;
      if (res == null) return;
      if (res.status == "success") {
        showSuccess(
          res.message,
        );
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
}
