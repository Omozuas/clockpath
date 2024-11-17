import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clockpath/apis/models/get_request_model.dart';
import 'package:clockpath/apis/models/get_workdays_model.dart';
import 'package:clockpath/apis/models/recent_activity_model.dart';
import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/api_services.dart';
import 'package:clockpath/apis/urls/connection_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeApi {
  ApiService apiService = ApiService(baseUrl: ConnectionUrls.baseUrl);
  HomeApi(this.ref);
  final Ref ref;
  //clockIn and clockOut

  Future<GeneralRespons> clockIn(
      {required double longitude, required double latitude}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
          endpoint: ConnectionUrls.clockInEndpoint,
          token: token,
          body: {"longitude": longitude, "latitude": latitude});

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> clockOut(
      {required double longitude, required double latitude}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
          endpoint: ConnectionUrls.clockOutEndpoint,
          token: token,
          body: {"longitude": longitude, "latitude": latitude});

      return response!;
    } catch (e) {
      rethrow;
    }
  }

//get
  Future<RecentActivityModel> getRecentResults() async {
    final token = await getAccessToken();

    try {
      final response = await apiService.get(
        endpoint: ConnectionUrls.getrecentActivityEndpoint,
        token: token,
      );
      final body = jsonDecode(response.body);

      return RecentActivityModel.fromJson(body);
    } on TimeoutException catch (_) {
      return RecentActivityModel(
        status: 'false',
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return RecentActivityModel(
        status: 'false',
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return RecentActivityModel(
        status: code ?? 'false',
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GetRequestModel> getRequest({required double limit}) async {
    final token = await getAccessToken();

    try {
      final response = await apiService.get(
        endpoint: '${ConnectionUrls.requestUserEndpoint}?limit=$limit',
        token: token,
      );
      final body = jsonDecode(response.body);

      return GetRequestModel.fromJson(body);
    } on TimeoutException catch (_) {
      return GetRequestModel(
        status: 'false',
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GetRequestModel(
        status: 'false',
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return GetRequestModel(
        status: code ?? 'false',
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GetWorkModel> getWorkDays() async {
    final token = await getAccessToken();

    try {
      final response = await apiService.get(
        endpoint: ConnectionUrls.workScheduleEndpoint,
        token: token,
      );
      final body = jsonDecode(response.body);

      return GetWorkModel.fromJson(body);
    } on TimeoutException catch (_) {
      return GetWorkModel(
        status: 'false',
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GetWorkModel(
        status: 'false',
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return GetWorkModel(
        status: code ?? 'false',
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
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

final homeApi = Provider<HomeApi>((ref) => HomeApi(ref));
