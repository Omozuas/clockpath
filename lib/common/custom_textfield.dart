import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    super.key,
    required this.firstText,
    required this.hintText,
    this.keyboardType,
    required this.controller,
    this.suffixIcon,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.onForgotPassword,
    this.autofocus = false,
    this.onChanged,
    this.maxLengthEnforcement,
    this.contentPadding,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.extraText, // Optional callback for "Forgot Password?"
  });
  final String? firstText, hintText, extraText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText, autofocus, readOnly;
  final VoidCallback? onForgotPassword; // Callback for when the link is tapped
  final Function(String)? onChanged;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength, maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstText ?? '',
          style: GoogleFonts.openSans(
            color: GlobalColors.textblackBoldColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          validator: validator,
          autofocus: autofocus,
          maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLengthEnforcement: maxLengthEnforcement,
          readOnly: readOnly,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlobalColors.textblackSmallColor,
                ),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xffBBC0C3), width: 1),
            ),
          ),
        ),
        if (onForgotPassword != null) // Only show if the callback is provided
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: onForgotPassword,
                child: Text(
                  extraText ?? '',
                  style: GoogleFonts.openSans(
                    color: GlobalColors.kDeepPurple,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
