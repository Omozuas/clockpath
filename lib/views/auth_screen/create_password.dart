import 'dart:developer';
import 'package:clockpath/apis/riverPod/auth_flow/auth_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/success_screens/password_succes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
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
  void signup() async {
    log(".....start");
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authProvider.notifier).setNewPassword(
            newPassword: password, confirmPassword: confirmPassword);
        final res = ref.read(authProvider).createPassword.value;
        if (res == null) return;
        if (res.status == 'success') {
          Get.offAll(() => const PasswordSuccesScreen());
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
    final isLoading = ref.watch(authProvider).createPassword.isLoading;
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
                        // Regular expressions for validation
                        final hasUppercase = RegExp(r'[A-Z]');
                        final hasLowercase = RegExp(r'[a-z]');
                        final hasDigits = RegExp(r'[0-9]');
                        final hasSpecialCharacters =
                            RegExp(r'[!@#$%^&*(),.?":{}|<>]');

                        if (!hasUppercase.hasMatch(value)) {
                          return 'Password must include at least one uppercase letter';
                        }
                        if (!hasLowercase.hasMatch(value)) {
                          return 'Password must include at least one lowercase letter';
                        }
                        if (!hasDigits.hasMatch(value)) {
                          return 'Password must include at least one number';
                        }
                        if (!hasSpecialCharacters.hasMatch(value)) {
                          return 'Password must include at least one special character';
                        }
                        return null; // Password is valid
                      },
                      hintText: 'New Password',
                      obscureText: _isPasswordObscured,
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
                        isLoading: isLoading,
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
