import 'dart:developer';

import 'package:clockpath/apis/riverPod/auth_flow/auth_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/success_screens/email_verified_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
    _emailController.addListener(_checkFormValidity);
    _codeController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // Check if both fields are not empty
  void _checkFormValidity() {
    final isEmailNotEmpty = _emailController.text.isNotEmpty;
    final isCodeNotEmpty = _codeController.text.isNotEmpty;

    setState(() {
      _isButtonEnabled = isEmailNotEmpty && isCodeNotEmpty;
    });
  }

  signup() async {
    final String email = _emailController.text;
    final String code = _codeController.text;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref
            .read(authProvider.notifier)
            .acceptInvite(email: email, code: code);
        final res = ref.read(authProvider).acceptRespons.value;
        if (res == null) return;
        if (res.status == 'success') {
          Get.offAll(() => const EmailVerifiedSuccess());
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
    final isLoading = ref.watch(authProvider).acceptRespons.isLoading;
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 357.w,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/logo/mainlogo.svg',
                            width: 56.w,
                            height: 56.h,
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            'Welcome to ClockPath',
                            style: GoogleFonts.playfairDisplay(
                              color: GlobalColors.textblackBoldColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Enter your email and invitation code to get started',
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
                    SizedBox(height: 30.h),
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
                    SizedBox(height: 20.h),
                    CustomTextFields(
                      controller: _codeController,
                      firstText: 'Invitation Code',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Code';
                        }
                        return null;
                      },
                      hintText: 'Enter code',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        FilteringTextInputFormatter.deny(RegExp(r',')),
                      ],
                    ),
                    SizedBox(height: 80.h),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        onTap: _isButtonEnabled
                            ? signup
                            : () {
                                log('no');
                              },
                        isLoading: isLoading,
                        decorationColor: _isButtonEnabled
                            ? GlobalColors.kDeepPurple
                            : GlobalColors.kLightpPurple,
                        text: 'Verify',
                        textColor: _isButtonEnabled
                            ? GlobalColors.textWhiteColor
                            : GlobalColors.kDLightpPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
