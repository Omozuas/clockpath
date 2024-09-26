import 'dart:developer';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/views/success_screens/password_succes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
    _passwordController.addListener(_checkFormValidity);
    _confirmPasswordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    });
  }

  // Check if both fields are not empty
  void _checkFormValidity() {
    final isPasswordNotEmpty = _passwordController.text.isNotEmpty;
    final isConfirmPasswordNotEmpty =
        _confirmPasswordController.text.isNotEmpty;

    setState(() {
      _isButtonEnabled = isPasswordNotEmpty && isConfirmPasswordNotEmpty;
    });
  }

  // Validate and Sign Up
  void signup() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.offAll(() => const PasswordSuccesScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Padding(
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
                              'Create Password',
                              style: GoogleFonts.playfairDisplay(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Create a strong password to secure your account and get started with ClockPath',
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
                    ),
                    SizedBox(height: 30.h),
                    CustomTextFields(
                      controller: _passwordController,
                      firstText: 'New Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your New Password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      hintText: 'New Password',
                      obscureText: _isPasswordObscured,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFields(
                      controller: _confirmPasswordController,
                      firstText: 'Confirm Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Confirm Password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      hintText: 'Enter Confirm Password',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      obscureText: _isConfirmPasswordObscured,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
                    SizedBox(height: 70.h),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        onTap: _isButtonEnabled
                            ? signup
                            : () {
                                log('Button is disabled');
                              },
                        decorationColor: _isButtonEnabled
                            ? GlobalColors.kDeepPurple
                            : GlobalColors.kLightpPurple,
                        text: 'Create Account',
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
