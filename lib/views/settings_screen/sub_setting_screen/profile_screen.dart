import 'dart:developer';
import 'dart:io';

import 'package:clockpath/apis/riverPod/setup_profile_flow/setup_profile_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/custom_button.dart';
import 'package:clockpath/common/custom_textfield.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _roleController = TextEditingController();

  XFile? _profileImage;
  String name = '', networkImg = '', person = '';
  List<Map<String, dynamic>> images = [];
  late Uint8List bytes;
  @override
  void initState() {
    super.initState();
    getImge();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void getImge() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      networkImg = preferences.getString('image') ?? '';
      _fullNameController.text = preferences.getString('name') ?? '';
      _roleController.text = preferences.getString('role') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    name = pickedImage?.name ?? '';
    bytes = await pickedImage?.readAsBytes() ?? bytes;
    images.add({"bytes": bytes, "path": name});
    setState(() {
      _profileImage = pickedImage;
      name = pickedImage!.name;
      bytes = bytes;
    });
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
          getImge();
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
    final isLoading = ref.watch(setupProfileProvider).setUpProfile.isLoading;
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset('assets/icons/backIcon.svg')),
                    Flexible(
                      child: SizedBox(
                        width: 100.w,
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.openSans(
                        color: GlobalColors.textblackBoldColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                  image: networkImg.isEmpty
                                      ? _profileImage == null
                                          ? const AssetImage(
                                                  'assets/icons/profile-circle.png')
                                              as ImageProvider
                                          : FileImage(
                                              File(_profileImage!.path),
                                            )
                                      : NetworkImage(networkImg),
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your Role/Title in Organization';
                          //   }
                          //   return null;
                          // },
                          hintText: 'Enter your Role/Title in Organization',
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'[,.]')),
                          ],
                          readOnly: true,
                        ),
                        SizedBox(height: 70.h),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                              onTap: proceed,
                              isLoading: isLoading,
                              decorationColor: GlobalColors.kDeepPurple,
                              text: 'Save Changes',
                              textColor: GlobalColors.textWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
