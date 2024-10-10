import 'package:clockpath/views/clock_history_screen/clock_history_screen.dart';
import 'package:clockpath/views/home_screen/home_screen.dart';
import 'package:clockpath/views/notifications/notifications_screen.dart';
import 'package:clockpath/views/requests/requests_screen.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt mainIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const ClockHistoryScreen(),
    const RequestsScreen(),
    const NotificationsScreen()
  ];
}
