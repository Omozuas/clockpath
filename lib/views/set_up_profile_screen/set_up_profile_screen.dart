import 'dart:developer';
import 'dart:io';

import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/auth_screen/login_screen.dart';
import 'package:clockpath/views/set_up_profile_screen/working_days_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SetUpProfileScreen extends ConsumerStatefulWidget {
  const SetUpProfileScreen({super.key});

  @override
  ConsumerState<SetUpProfileScreen> createState() => _SetUpProfileScreenState();
}

class _SetUpProfileScreenState extends ConsumerState<SetUpProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _roleController = TextEditingController();
  bool _isButtonEnabled = false;
  XFile? _profileImage;

  late Uint8List bytes;
  List<Map<String, dynamic>> images = [];
  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_checkFormValidity);
    _roleController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  // Check if both fields are not empty
  void _checkFormValidity() {
    final isfullNameControllerNotEmpty = _fullNameController.text.isNotEmpty;
    final isroleControllerNotEmpty = _roleController.text.isNotEmpty;

    setState(() {
      _isButtonEnabled =
          isfullNameControllerNotEmpty && isroleControllerNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    String name = pickedImage?.name ?? '';
    bytes = await pickedImage?.readAsBytes() ?? bytes;
    images.add({"bytes": bytes, "path": name});
    setState(() {
      _profileImage = pickedImage;
      name = pickedImage!.name;
      bytes = bytes;
      log(',name:$name');
    });
  }

  // Validate and Sign Up
  void proceed() async {
    List<MapEntry<String, String>> formData = FormData({
      "full_name": _fullNameController.text,
      "role": _roleController.text,
    }).fields;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref
            .read(setupProfileProvider.notifier)
            .setupProfilee(data: formData, images: images);
        final res = ref.read(setupProfileProvider).setUpProfile.value;
        if (res == null) return;
        if (res.status == "success") {
          showSuccess(
            res.message,
          );
          Get.to(() => const WorkingDaysScreen());
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

  // Function to request permission and handle denied/approved cases
  Future<void> _checkPermissionAndPickImage() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      _pickImage(); // Permission is already granted, pick the image
    } else {
      await Permission.storage.request(); // Request permission
      _pickImage(); // Then pick the image
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(setupProfileProvider).setUpProfile.isLoading;
    return Scaffold(
      backgroundColor: GlobalColors.textWhiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Set Up Your Profile',
                      style: GoogleFonts.playfairDisplay(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Set up your profile to personalize your experience and keep your details up to date',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackSmallColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        Container(
                          height: 110.h,
                          width: 110.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: GlobalColors.lightGrayeColor,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _profileImage == null
                                  ? const AssetImage(
                                          'assets/icons/profile-circle.png')
                                      as ImageProvider
                                  : FileImage(
                                      File(_profileImage!.path),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _checkPermissionAndPickImage,
                            child: Container(
                              height: 32.h,
                              width: 32.w,
                              decoration: BoxDecoration(
                                color: GlobalColors.kDeepPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: GlobalColors.textWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Upload Profile photo',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackSmallColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Divider(
                      color: GlobalColors.lightGrayeColor,
                    ),
                    SizedBox(height: 30.h),
                    CustomTextFields(
                      controller: _fullNameController,
                      firstText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Full Name';
                        }
                        return null;
                      },
                      hintText: 'Full Name',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[,.]')),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomTextFields(
                      controller: _roleController,
                      firstText: 'Role/Title in Organization',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Role/Title in Organization';
                        }
                        return null;
                      },
                      hintText: 'Enter your Role/Title in Organization',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[,.]')),
                      ],
                    ),
                    SizedBox(height: 70.h),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        onTap: _isButtonEnabled ? proceed : () {},
                        decorationColor: _isButtonEnabled
                            ? GlobalColors.kDeepPurple
                            : GlobalColors.kLightpPurple,
                        isLoading: isLoading,
                        text: 'Next',
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
