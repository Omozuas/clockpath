import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatefulWidget {
  const CustomDropdownField(
      {super.key,
      required this.firstText,
      required this.hintText,
      required this.items, // List of items for dropdown
      this.onChanged,
      this.validator,
      this.initialValue,
      this.suffixIcon,
      this.extraText,
      this.onForgotPassword,
      this.contentPadding});

  final String? firstText, hintText, extraText;
  final List<String> items; // List of dropdown items
  final String? initialValue;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final VoidCallback? onForgotPassword;
  final EdgeInsetsGeometry? contentPadding;

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Set initial value if provided
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.firstText ?? '',
          style: GoogleFonts.openSans(
            color: GlobalColors.textblackBoldColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5.h),
        DropdownButtonFormField<String>(
          dropdownColor: GlobalColors.textWhiteColor,
          iconSize: 25,
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: GlobalColors.textblackSmallColor,
          ),
          value: _selectedValue,
          validator: widget.validator,
          focusColor: Colors.transparent,
          onChanged: (value) {
            setState(() {
              _selectedValue = value; // Update selected value
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlobalColors.textblackSmallColor,
                ),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide:
                  BorderSide(color: GlobalColors.lightGrayeColor, width: 1),
            ),
          ),
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.openSans(
                  color: GlobalColors.textblackSmallColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
