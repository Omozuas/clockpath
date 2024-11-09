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
}

final setupProfileApi =
    Provider<SetupprofileApi>((ref) => SetupprofileApi(ref));
