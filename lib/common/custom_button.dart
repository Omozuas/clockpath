import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.decorationColor,
      required this.text,
      this.border = false,
      required this.textColor});
  final VoidCallback onTap;
  final String text;
  final Color decorationColor, textColor;
  final bool border;
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
          border: widget.border
              ? Border.all(width: 1, color: GlobalColors.kDeepPurple)
              : const Border(
                  top: BorderSide.none,
                  bottom: BorderSide.none,
                  left: BorderSide.none,
                  right: BorderSide.none),
        ),
        child: Center(
          child: Text(
            widget.text,
            softWrap: true,
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
