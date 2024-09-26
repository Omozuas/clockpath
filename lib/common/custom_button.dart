import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.decorationColor,
      required this.text,
      required this.textColor});
  final VoidCallback onTap;
  final String text;
  final Color decorationColor, textColor;
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 60.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: widget.decorationColor,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.openSans(
              color: widget.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
