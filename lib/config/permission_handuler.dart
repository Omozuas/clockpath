import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionsMethods {
  Future<void> askCameraPermission() async {
    // Check the current permission status
    if (await Permission.photos.isDenied) {
      // If permission is denied, request it
      PermissionStatus status = await Permission.photos.request();

      // Handle the result
      if (status.isGranted) {
        log("Photo permission granted");
      } else if (status.isDenied) {
        log("Photo permission denied");
      } else if (status.isPermanentlyDenied) {
        log("Photo permission permanently denied. Go to settings to enable.");
        // You might want to open app settings here
        openAppSettings();
      }
    } else if (await Permission.photos.isPermanentlyDenied) {
      // Handle permanently denied permission
      log("Photo permission permanently denied. Go to settings to enable.");
      openAppSettings();
    }
  }
}
