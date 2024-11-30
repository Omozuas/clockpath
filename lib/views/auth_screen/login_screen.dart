import 'dart:developer';

import 'package:clockpath/apis/riverPod/auth_flow/auth_provider.dart';
import 'package:clockpath/apis/services/push_notification.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/forgot_password_screen.dart';
import 'package:clockpath/views/main_screen/main_screen.dart';
import 'package:clockpath/views/set_up_profile_screen/set_up_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPasswordObscured = true;
  String networkImg = '', fullName = '';
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  @override
  void initState() {
    super.initState();
    // Listen to changes in both TextEditingControllers
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  // Check if both fields are not empty
  void _checkFormValidity() {
    final isEmailNotEmpty = _emailController.text.isNotEmpty;
    final isCodeNotEmpty = _passwordController.text.isNotEmpty;

    setState(() {
      _isButtonEnabled = isEmailNotEmpty && isCodeNotEmpty;
    });
  }

  void getImge() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      networkImg = preferences.getString('image') ?? '';
      fullName = preferences.getString('name') ?? '';
    });
    if (networkImg.isNotEmpty && fullName.isNotEmpty) {
      Get.offAll(() => const MainScreen());
    } else {
      Get.offAll(() => const SetUpProfileScreen());
    }
  }

  // Validate and Sign Up
  void login() async {
    log(".....start");
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final deviceToken = await pushNotificationService.generateDeviceToken();

    if (_formKey.currentState?.validate() ?? false) {
      log('my device $deviceToken');
      try {
        await ref.read(authProvider.notifier).login(
            email: email, password: password, deviceToken: deviceToken ?? '');
        final res = ref.read(authProvider).loginRespons.value;
        if (res == null) return;
        if (res.status == "success") {
          showSuccess(
            res.message,
          );
          getImge();
          log('my device $deviceToken');
        } else {
          log(res.message);
          showError(
            res.message,
          );
          if (res.message ==
              'Invalid or expired token. Please sign in again.') {
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).loginRespons.isLoading;
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
                              'Welcome Back!',
                              style: GoogleFonts.playfairDisplay(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Log in to access your account and manage your time with ClockPath',
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
                      controller: _passwordController,
                      firstText: 'Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your  Password';
                        }

                        return null;
                      },
                      hintText: 'Password',
                      obscureText: _isPasswordObscured,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      onForgotPassword: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      extraText: 'Forgot Password?',
                    ),
                    SizedBox(height: 50.h),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        onTap: _isButtonEnabled
                            ? login
                            : () {
                                log('no');
                              },
                        isLoading: isLoading,
                        decorationColor: _isButtonEnabled
                            ? GlobalColors.kDeepPurple
                            : GlobalColors.kLightpPurple,
                        text: 'Login',
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
