import 'dart:async';

import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/api_services.dart';
import 'package:clockpath/apis/urls/connection_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsApi {
  ApiService apiService = ApiService(baseUrl: ConnectionUrls.baseUrl);
  SettingsApi(this.ref);
  final Ref ref;
  //clockIn and clockOut

  Future<GeneralRespons> requestUser(
      {required String requestType,
      required String reason,
      required String note,
      required String startDate,
      required String endDate}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
          endpoint: ConnectionUrls.requestUserEndpoint,
          token: token,
          body: {
            "requestType": requestType,
            "reason": reason,
            "note": note,
            "startDate": startDate,
            "endDate": endDate
          });

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> managePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
          endpoint: ConnectionUrls.managePasswordEndpoint,
          token: token,
          body: {
            "current_password": currentPassword,
            "new_password": newPassword,
            "confirm_password": confirmPassword
          });

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> logOut() async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post1(
        endpoint: ConnectionUrls.logoutEndpoint,
        token: token,
      );

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> registerDevice(
      {required String deviceToken, required String platform}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
          endpoint: ConnectionUrls.registerDeviceEndpoint,
          token: token,
          body: {"deviceToken": deviceToken, "platform": platform});

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAccessToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('access_token') ?? '';
  }

  Future<String> getRefreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('refresh_token') ?? '';
  }

  void saveUserDids(GeneralRespons? response) async {
    if (response == null) return;
    final image = response.data["data"]["image"]["imageUrl"];
    final name = response.data["data"]["full_name"];
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('image', image);
    preferences.setString('name', name);
  }
}

final settingsApi = Provider<SettingsApi>((ref) => SettingsApi(ref));
