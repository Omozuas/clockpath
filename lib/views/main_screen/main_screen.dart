import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/controller/main_controller/main_controller.dart';
import 'package:clockpath/views/requests/new_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor1,
      body: SafeArea(
        child: Obx(
          // Only the screen that depends on the observable index is wrapped in Obx
          () => controller.screens[controller.mainIndex.value],
        ),
      ),
      floatingActionButton: Obx(
        // Wrap FAB inside Obx to reactively show/hide it based on mainIndex
        () => controller.mainIndex.value == 2
            ? FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  // Add your onPressed code here!
                  Get.to(() => const NewRequest());
                },
                backgroundColor: GlobalColors.kDeepPurple,
                child: SvgPicture.asset('assets/icons/edit2.svg'),
              )
            : Container(),
      ), // Hide FAB for other screens
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Obx(
        // Wrap only the BottomNavigationBar that depends on the mainIndex observable
        () => BottomNavigationBar(
          backgroundColor: GlobalColors.backgroundColor2,
          selectedItemColor: GlobalColors.kDeepPurple,
          elevation: 0,

          unselectedItemColor: GlobalColors.grayColor,
          type: BottomNavigationBarType.fixed,
          currentIndex:
              controller.mainIndex.value, // Ensure to update the currentIndex
          onTap: (index) =>
              controller.mainIndex.value = index, // Update the index
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/logo/home.svg',
                // ignore: deprecated_member_use
                color: controller.mainIndex.value == 0
                    ? GlobalColors.kDeepPurple
                    : GlobalColors.grayColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/logo/timer.svg',
                // ignore: deprecated_member_use
                color: controller.mainIndex.value == 1
                    ? GlobalColors.kDeepPurple
                    : GlobalColors.grayColor,
              ),
              label: 'Clock History',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/logo/document-text.svg',
                // ignore: deprecated_member_use
                color: controller.mainIndex.value == 2
                    ? GlobalColors.kDeepPurple
                    : GlobalColors.grayColor,
              ),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/logo/notification.svg',

                // ignore: deprecated_member_use
                color: controller.mainIndex.value == 3
                    ? GlobalColors.kDeepPurple
                    : GlobalColors.grayColor,
              ),
              label: 'Notifications',
            ),
          ],
        ),
      ),
    );
  }
}
