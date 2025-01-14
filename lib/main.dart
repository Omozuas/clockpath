import 'package:clockpath/apis/services/push_notification.dart';
import 'package:clockpath/color_theme/themes.dart';
import 'package:clockpath/config/permission_handuler.dart';
import 'package:clockpath/firebase_options.dart';
import 'package:clockpath/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Make app always in portrait
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  PushNotificationService pushNotificationService = PushNotificationService();
  PermissionsMethods permissionsMethods = PermissionsMethods();
  await permissionsMethods.askNotificationPermission();
  pushNotificationService.initNotification();
  pushNotificationService.generateDeviceToken();
  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (context, child) {
          return GetMaterialApp(
            title: 'ClockPath',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: GlobalColors.textWhiteColor,
              iconTheme: IconThemeData(color: GlobalColors.textblackBoldColor),
              useMaterial3: true,
            ),
            home: start,
            navigatorKey: navigatorKey,
          );
        });
  }
}

Widget start = const SplashScreen();
