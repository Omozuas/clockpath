import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields(
      {super.key,
      required this.firstText,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      this.suffixIcon,
      this.inputFormatters,
      this.validator,
      this.obscureText = false});
  final String firstText, hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstText,
          style: GoogleFonts.openSans(
            color: GlobalColors.textblackBoldColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 80.h,
          child: TextFormField(
            controller: controller,
            validator: validator,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GlobalColors.textblackSmallColor,
                  ),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    const BorderSide(color: Color(0xffBBC0C3), width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
