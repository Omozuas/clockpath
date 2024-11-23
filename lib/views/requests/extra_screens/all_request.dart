import 'dart:developer';

import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/common/snackbar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllRequest extends ConsumerStatefulWidget {
  const AllRequest({super.key});

  @override
  ConsumerState<AllRequest> createState() => _AllRequestState();
}

class _AllRequestState extends ConsumerState<AllRequest> {
  double page = 30;
  bool loading = false;
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => getAllRequest());
    _scrollController = ScrollController()
      ..addListener(() {
        // Trigger when the user scrolls to the bottom
        if (loading) return;
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            loading = true;
          });
          page = page + 10;
          ref.read(getRequestProvider.notifier).getRequest(limit: page);
          setState(() {
            loading = false;
          });
        }
      });
  }

  void getAllRequest() async {
    try {
      await ref.read(getRequestProvider.notifier).getRequest(limit: page);
      final res = ref.read(getRequestProvider).value;
      if (res == null) return;
      if (res.status == "success") {
        // showSuccess(
        //   res.message,
        // );
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

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(getRequestProvider);
    ref.watch(getRecentActivityProvider);
    ref.watch(getWorkDaysProvider);
    ref.watch(getNotificationProvider);
    return data.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (info) {
          final data = info?.data?.data;
          if (data != null) {
            return ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final request = data[index];
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
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
                        borderRadius: BorderRadius.circular(
                            16.r), // Responsive border radius
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
                                        image: AssetImage(
                                            'assets/icons/house.png'))),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.reason ?? '',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(
                                      color: GlobalColors.textblackBoldColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    request.startDate != null
                                        ? DateFormat('d/MM/yyyy')
                                            .format(request.startDate!)
                                        : '',
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
                          if (request.status == 'accepted')
                            Container(
                              height: 26.h,
                              width: 75.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16.r),
                                color: GlobalColors.lightGreen,
                              ),
                              child: Center(
                                child: Text(
                                  'Approved',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: GoogleFonts.openSans(
                                    color: GlobalColors.deepGreen,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (request.status == 'pending')
                            Container(
                              height: 26.h,
                              width: 75.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16.r),
                                color: GlobalColors.lightyellow,
                              ),
                              child: Center(
                                child: Text(
                                  'Pending',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: GoogleFonts.openSans(
                                    color: GlobalColors.deepyello,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (request.status == 'declined')
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
          return const Text('empty');
        },
        error: (e, s) {
          return Text('$e,$s');
        },
        loading: () => const Text('..loading'));
  }
}
