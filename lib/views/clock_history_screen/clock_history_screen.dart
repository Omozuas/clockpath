import 'package:clockpath/color_theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

class ClockHistoryScreen extends StatefulWidget {
  const ClockHistoryScreen({super.key});

  @override
  State<ClockHistoryScreen> createState() => _ClockHistoryScreenState();
}

class _ClockHistoryScreenState extends State<ClockHistoryScreen> {
  bool showDatePickerFlag = false;
  DateTime? selectedDate;
  String new1 = 'Selected Date';

  final dateFormat = DateFormat('dd MMMM, yyyy');

  Future<void> _selectDate(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      type: OmniDateTimePickerType.date,
      firstDate: DateTime.now(),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      theme: Theme.of(context).copyWith(
        // ignore: deprecated_member_use
        useMaterial3: false,
        colorScheme: ColorScheme.light(
          primary: GlobalColors.kDeepPurple,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        dialogBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: GlobalColors.kDeepPurple,
          ),
        ),
      ),
    );
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
        showDatePickerFlag = true;
        new1 = dateFormat.format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = _generateDateDropdownItems();
    // If the selectedDate is not in the list, set it to null
    if (selectedDate != null &&
        !dropdownItems.any((item) => item.value == selectedDate)) {
      selectedDate = null;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Clock History',
              textAlign: TextAlign.center,
              softWrap: true,
              style: GoogleFonts.openSans(
                color: GlobalColors.textblackBoldColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                width: 1.w,
                color: GlobalColors.lightGrayeColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      height: 25.h,
                      width: 25.w,
                    ),
                  ),
                  SizedBox(width: 55.w),
                  Expanded(
                    child: DropdownButton<DateTime>(
                      isExpanded: true,
                      dropdownColor: GlobalColors.textWhiteColor,
                      value: selectedDate,
                      icon: SvgPicture.asset(
                        'assets/icons/arrowdown.svg',
                        height: 25.h,
                        width: 25.w,
                      ),
                      hint: Text(
                        new1,
                        style: TextStyle(
                          color: GlobalColors.lightGrayeColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      items: dropdownItems,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue;
                          new1 = dateFormat.format(selectedDate!);
                        });
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.w, // Responsive border width
                  color: GlobalColors.lightGrayeColor,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: GlobalColors.lightBlueColor,
                    ),
                    height: 37.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Date',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.textblackBoldColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Clock In',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.textblackBoldColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Clock Out',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.openSans(
                            color: GlobalColors.textblackBoldColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Clock History Yet',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackBoldColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'You havent clocked in yet. Start your first shift to see your work hours here',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                          color: GlobalColors.textblackSmallColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
                  // Expanded(
                  //   child:

                  //   ListView.builder(
                  //     itemCount: 30,
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //           color: GlobalColors.backgroundColor2,
                  //         ),
                  //         height: 37.h,
                  //         child: Padding(
                  //           padding: EdgeInsets.only(bottom: 0, top: 10.h),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   Text(
                  //                     '17/05/2025',
                  //                     textAlign: TextAlign.center,
                  //                     softWrap: true,
                  //                     style: GoogleFonts.openSans(
                  //                       color: GlobalColors.textblackBoldColor,
                  //                       fontSize: 12.sp,
                  //                       fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     '09:00 AM',
                  //                     textAlign: TextAlign.center,
                  //                     softWrap: true,
                  //                     style: GoogleFonts.openSans(
                  //                       color: GlobalColors.textblackBoldColor,
                  //                       fontSize: 14.sp,
                  //                       fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     '05:00 PM',
                  //                     textAlign: TextAlign.center,
                  //                     softWrap: true,
                  //                     style: GoogleFonts.openSans(
                  //                       color: GlobalColors.textblackBoldColor,
                  //                       fontSize: 14.sp,
                  //                       fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Divider(
                  //                 height: 1.h, // Responsive divider width
                  //                 indent: 30.h, // Responsive indent
                  //                 endIndent: 30.h, // Responsive end indent
                  //                 color: GlobalColors.lightGrayeColor,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<DateTime>> _generateDateDropdownItems() {
    List<DateTime> dates =
        List.generate(30, (index) => DateTime.now().add(Duration(days: index)));
    return dates.map((date) {
      return DropdownMenuItem<DateTime>(
        value: date,
        child: Text(
          dateFormat.format(date),
          style: TextStyle(fontSize: 16.sp),
        ),
      );
    }).toList();
  }
}
