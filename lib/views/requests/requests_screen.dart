import 'package:clockpath/apis/riverPod/get_notification/get_notification_provider.dart';
import 'package:clockpath/apis/riverPod/get_recent_actibity/get_recent_activity.dart';
import 'package:clockpath/apis/riverPod/get_request/get_request.dart';
import 'package:clockpath/apis/riverPod/get_workdays/get_workdays_provider.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/views/requests/extra_screens/all_request.dart';
import 'package:clockpath/views/requests/extra_screens/approved_request.dart';
import 'package:clockpath/views/requests/extra_screens/pending_request.dart';
import 'package:clockpath/views/requests/extra_screens/rejected_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(getRecentActivityProvider);
    ref.watch(getRequestProvider);
    ref.watch(getWorkDaysProvider);
    ref.watch(getNotificationProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'My Requests',
              textAlign: TextAlign.center,
              softWrap: true,
              style: GoogleFonts.openSans(
                color: GlobalColors.textblackBoldColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h), // Added spacing
          Expanded(
            child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Column(
                children: [
                  TabBar(
                    dividerColor: Colors.transparent,
                    labelStyle: GoogleFonts.openSans(
                      color: GlobalColors.textblackBoldColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Approved'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Rejected'),
                    ],
                    labelColor: GlobalColors.textblackBoldColor,
                    unselectedLabelColor: GlobalColors.lightGrayeColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        AllRequest(),
                        ApprovedRequest(),
                        PendingRequest(),
                        RejectedRequest()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
