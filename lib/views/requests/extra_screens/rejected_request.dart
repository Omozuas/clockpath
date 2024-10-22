import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectedRequest extends StatefulWidget {
  const RejectedRequest({super.key});

  @override
  State<RejectedRequest> createState() => _RejectedRequestState();
}

class _RejectedRequestState extends State<RejectedRequest> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
            child: Container(
              height: 68.h, // Responsive container height
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.w, // Responsive border width
                  color: GlobalColors.lightGrayeColor,
                ),
                color: GlobalColors.backgroundColor2,
                borderRadius:
                    BorderRadius.circular(16.r), // Responsive border radius
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 48.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: GlobalColors.kLightpPurple,
                            image: const DecorationImage(
                                image: AssetImage('assets/icons/house.png'))),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sick Leave',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: GoogleFonts.openSans(
                              color: GlobalColors.textblackBoldColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '17/05/2025',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: GoogleFonts.openSans(
                              color: GlobalColors.textblackSmallColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 26.h,
                    width: 75.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.r),
                      color: GlobalColors.lightred,
                    ),
                    child: Center(
                      child: Text(
                        'Rejected',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.deepred,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
