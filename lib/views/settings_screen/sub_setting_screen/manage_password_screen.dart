import 'dart:developer';

import 'package:clockpath/apis/riverPod/settings_provider/settings_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_popup.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagePasswordScreen extends ConsumerStatefulWidget {
  const ManagePasswordScreen({super.key});

  @override
  ConsumerState<ManagePasswordScreen> createState() =>
      _ManagePasswordScreenState();
}

class _ManagePasswordScreenState extends ConsumerState<ManagePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isCurrentPasswordObscured = true;
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

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordObscured = !_isCurrentPasswordObscured;
    });
  }

  void proceed() async {
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    final String currentPassword = _currentPasswordController.text;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(settingsProvider.notifier).managePassword(
            currentPassword: currentPassword,
            newPassword: password,
            confirmPassword: confirmPassword);
        final res = ref.read(settingsProvider).managePassword.value;
        if (res == null) return;
        if (res.status == 'success') {
          showSuccess(res.message);
          _clearSessionData();
          Get.offAll(() => const LoginScreen());
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

  Future<void> _clearSessionData() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('resetToken');
    preferences.remove('refresh_token');
    preferences.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(settingsProvider).managePassword.isLoading;
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: 10.h, bottom: 20.h, right: 20.w, left: 20.w),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset('assets/icons/backIcon.svg')),
                  Flexible(
                    child: SizedBox(
                      width: 80.w,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Manage Password',
                      style: GoogleFonts.playfairDisplay(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To change your password, enter your current password followed by your new password twice for confirmation',
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.textblackSmallColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
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
                        CustomTextFields(
                          controller: _currentPasswordController,
                          firstText: 'Current Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Current Password';
                            }

                            return null;
                          },
                          hintText: 'Enter Password',
                          obscureText: _isCurrentPasswordObscured,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isCurrentPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _toggleCurrentPasswordVisibility,
                          ),
                        ),
                        SizedBox(height: 20.h),
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
                          hintText: 'Enter new password',
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
                          hintText: 'Re-type new password',
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
                              onTap: () => showCustomPopup(
                                  context: context,
                                  boxh: 220.h,
                                  boxw: 254.w,
                                  decorationColor: GlobalColors.kDeepPurple,
                                  firstText: 'Change Password',
                                  secondText:
                                      'Atempting to change password will logout from your account?',
                                  proceed: () {
                                    Get.back();
                                    proceed();
                                  }),
                              isLoading: isLoading,
                              decorationColor: GlobalColors.kDeepPurple,
                              text: 'Save New Password',
                              textColor: GlobalColors.textWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
