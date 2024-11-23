import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/api_services.dart';
import 'package:clockpath/apis/urls/connection_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  ApiService apiService = ApiService(baseUrl: ConnectionUrls.baseUrl);
  AuthServices(this.ref);
  final Ref ref;

  Future<GeneralRespons> acceptInvite(
      {required String email, required String code}) async {
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.acceptInviteEndpoint,
        body: {'email': email, 'otp': code},
      );
      saveAccessToken(response);
      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> createPassword(
      {required String newPassword, required String confirmPassword}) async {
    final token = await getAccessToken();
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.setNewPasswordEndpoint,
        token: token,
        body: {
          "new_password": newPassword,
          "confirm_password": confirmPassword
        },
      );

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> loginRespons(
      {required String email, required String password}) async {
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.loginEndpoint,
        body: {"email": email, "password": password},
      );
      saveToken(response);

      saveUserDids(response);
      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.forgotPasswordEndpoint,
        body: {
          "email": email,
        },
      );
      return response!;
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralRespons> oneTimePin({
    required String otp,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.oneTimePinEndpoint,
        body: {
          "otp": otp,
        },
      );
      saveRestToken(response);
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

  Future<GeneralRespons> restPassword(
      {required String newPassword, required String confirmPassword}) async {
    final token = await getresetToken();
    try {
      final response = await apiService.post(
        endpoint: ConnectionUrls.resetPasswordEndpoint,
        token: token,
        body: {
          "new_password": newPassword,
          "confirm_password": confirmPassword
        },
      );

      return response!;
    } catch (e) {
      rethrow;
    }
  }

  void saveToken(GeneralRespons? response) async {
    if (response!.accessToken == null) return;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('access_token', response.accessToken!);
    preferences.setString('refresh_token', response.refreshToken!);
    preferences.setString('userID', response.data!['user']['_id']);
    return;
  }

  void saveAccessToken(GeneralRespons? response) async {
    if (response!.data == null) return;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('access_token', response.data!['accessToken']);

    return;
  }

  void saveRestToken(GeneralRespons? response) async {
    if (response == null) return;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('resetToken', response.data!['resetToken']);
    return;
  }

  Future<String> getresetToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('resetToken') ?? '';
  }

  Future<String> getuserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('userID') ?? '';
  }

  void saveUserDids(GeneralRespons? response) async {
    if (response!.success == false) return;
    final image = response.data["user"]["image"]["imageUrl"];
    final name = response.data["user"]["full_name"];
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('image', image);
    preferences.setString('name', name);
  }
}

final authServicesProvider = Provider<AuthServices>((ref) => AuthServices(ref));
