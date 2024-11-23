import 'dart:developer';

import 'package:clockpath/apis/models/recent_activity_model.dart';
import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:clockpath/views/clock_history_screen/result_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

class ClockHistoryScreen extends ConsumerStatefulWidget {
  const ClockHistoryScreen({super.key});

  @override
  ConsumerState<ClockHistoryScreen> createState() => _ClockHistoryScreenState();
}

class _ClockHistoryScreenState extends ConsumerState<ClockHistoryScreen> {
  bool showDatePickerFlag = false;
  DateTime? selectedDate;
  String new1 = 'Selected Date';
  List<Result>? allResults;
  final dateFormat = DateFormat('dd MMMM, yyyy');

  Future<void> _selectDate(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      type: OmniDateTimePickerType.date,
      firstDate: DateTime(2000),
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
    log('datetime $dateTime');

    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;

        showDatePickerFlag = true;
        new1 = dateFormat.format(selectedDate!);
        getFilteredResults();
      });
      log('selectedDate1 $selectedDate');
    }
    log('selectedDate $selectedDate');
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() => getRecentResults());
  }

  Future<void> getRecentResults() async {
    log('showerr......');
    await ref.read(getRecentActivityProvider.notifier).getRecentResults();
    final res = ref.watch(getRecentActivityProvider).value;
    log('showerr..1${res?.message}');
    if (res == null) return;

    if (res.status != 'success') {
      showError(res.message);
      log('showerr..2${res.message}');
      return;
    }
    // Save all results for later filtering
    setState(() {
      allResults = res.data?.results;
    });
  }

  List<Result> getFilteredResults() {
    if (selectedDate == null || allResults == null) return allResults ?? [];

    // Format `selectedDate` to match the `Result.date` format
    final formattedSelectedDate = DateFormat('d/M/yyy').format(selectedDate!);
    log(formattedSelectedDate);
    // Filter the results based on the selected date
    final filteredResults = allResults!
        .where((result) => result.date == formattedSelectedDate)
        .toList();

    // Log the number of filtered results
    log('Number of results matching the date $formattedSelectedDate: ${filteredResults.length}');

    // Log each filtered result
    for (var result in filteredResults) {
      if (result.clockInTime != null) {
        Get.to(() => const ResultHistory(), arguments: {
          'date': result.date,
          'clockInTime': result.clockInTime,
          'clockOutTime': result.clockOutTime
        });
      }
      log('Filtered Result - Date: ${result.date}, Clock In: ${result.clockInTime}, Clock Out: ${result.clockOutTime}, Status: ${result.status}, Hours Worked: ${result.hoursWorked}');
    }

    return filteredResults;
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = _generateDateDropdownItems();
    // If the selectedDate is not in the list, set it to null
    if (selectedDate != null &&
        !dropdownItems.any((item) => item.value == selectedDate)) {
      selectedDate = null;
    }
    final recentAct = ref.watch(getRecentActivityProvider);
    ref.watch(getRequestProvider);
    ref.watch(getWorkDaysProvider);
    ref.watch(getRequestProvider);
    ref.watch(getNotificationProvider);
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
                          getFilteredResults();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: GlobalColors.lightBlueColor,
                    ),
                    height: 37.h,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Date',
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Clock In',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Clock Out',
                              textAlign: TextAlign.end,
                              softWrap: true,
                              style: GoogleFonts.openSans(
                                color: GlobalColors.textblackBoldColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  recentAct.when(
                      skipLoadingOnReload: true,
                      skipLoadingOnRefresh: true,
                      data: (data) {
                        // Use the filtered results based on `selectedDate`
                        // var filteredResults = getFilteredResults();
                        // Use the filtered results based on `selectedDate`
                        // var filteredResults = getFilteredResults();
// Get all results from the API response
                        final allResults = data?.data?.results ?? [];
                        log('selectedDate3 $selectedDate');
                        // Reorder the results to move the selected date to the top
                        List<Result> reorderedResults = List.from(allResults);
                        if (selectedDate != null) {
                          final formattedSelectedDate =
                              DateFormat('d/M/yyyy').format(selectedDate!);
                          log('$formattedSelectedDate hhh');
                          reorderedResults.sort((a, b) {
                            if (a.date == formattedSelectedDate) {
                              return -1; // Move the selected date to the top
                            } else if (b.date == formattedSelectedDate) {
                              return 1;
                            }
                            return 0; // Keep the rest in their original order
                          });
                        }

                        if (allResults.isEmpty) {
                          return Expanded(
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
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                              itemCount: allResults.length,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = allResults[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: GlobalColors.backgroundColor2,
                                  ),
                                  height: 37.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 0, top: 10.dg),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, right: 20.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.date ?? '',
                                                  textAlign: TextAlign.start,
                                                  softWrap: true,
                                                  style: GoogleFonts.openSans(
                                                    color: GlobalColors
                                                        .textblackBoldColor,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item.clockInTime ?? '',
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  style: GoogleFonts.openSans(
                                                    color: GlobalColors
                                                        .textblackBoldColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item.clockOutTime ??
                                                      '-------------',
                                                  textAlign: TextAlign.end,
                                                  softWrap: true,
                                                  style: GoogleFonts.openSans(
                                                    color: GlobalColors
                                                        .textblackBoldColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height:
                                              1.h, // Responsive divider width
                                          indent: 23.h, // Responsive indent
                                          endIndent:
                                              23.h, // Responsive end indent
                                          color: GlobalColors.lightGrayeColor,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                      error: (e, s) {
                        return Text('$e,$s');
                      },
                      loading: () => const Text('..loading')),
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
