import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/api_services.dart';
import 'package:clockpath/apis/urls/connection_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupprofileApi {
  ApiService apiService = ApiService(baseUrl: ConnectionUrls.baseUrl);
  SetupprofileApi(this.ref);
  final Ref ref;

  Future<GeneralRespons> setupProfile(
      {required List<MapEntry<String, dynamic>> data,
      List<Map<String, dynamic>>? images}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.multPathpost(
          endpoint: ConnectionUrls.setupProfileEndpoint,
          token: token,
          data: data,
          images: images);
      saveUserDids(response);
      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> updateProfile(
      {required List<MapEntry<String, dynamic>> data,
      List<Map<String, dynamic>>? images}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.multPathput(
          endpoint: ConnectionUrls.setupProfileEndpoint,
          token: token,
          data: data,
          images: images);
      saveUserDids(response);
      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> setupPWordDays(
      {required List<Map<String, dynamic>> work}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.put(
          endpoint: ConnectionUrls.setupWorkDaysEndpoint,
          token: token,
          body: {"work_days": work});

      return response!;
    } catch (e) {
      rethrow;
    }
  }

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
    final role = response.data["data"]["role"];
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('image', image);
    preferences.setString('name', name);
    preferences.setString('role', role);
  }
}

final setupProfileApi =
    Provider<SetupprofileApi>((ref) => SetupprofileApi(ref));
