import 'dart:developer';

import 'package:clockpath/apis/riverPod/auth_flow/auth_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/one_time_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  // Validate and Sign Up
  void proceed() async {
    log(".....start");
    final String email = _emailController.text;
    if (_formKey.currentState?.validate() ?? false) {
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
          Get.to(
            () => const OneTimeOtpScreen(),
            arguments: {
              'email': email,
            },
          );
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
    final isLoading = ref.watch(authProvider).forgotPassword.isLoading;
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/logo/mainlogo.svg',
                          width: 56.w,
                          height: 56.h,
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          'Forgot Your Password?',
                          style: GoogleFonts.playfairDisplay(
                            color: GlobalColors.textblackBoldColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Dont worry! Enter your email to receive instructions on how to reset your password',
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
                  ),
                  SizedBox(height: 50.h),
                  CustomTextFields(
                    controller: _emailController,
                    firstText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    hintText: 'Enter email',
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.deny(RegExp(r',')),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        onTap: proceed,
                        isLoading: isLoading,
                        decorationColor: GlobalColors.kDeepPurple,
                        text: 'Submit',
                        textColor: GlobalColors.textWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
