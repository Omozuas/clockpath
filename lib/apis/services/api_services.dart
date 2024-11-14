import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<GeneralRespons?> post(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? token}) async {
    log('$token');
    try {
      var response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));
      log(response.body);
      return generalResponsFromJson(response.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;

      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GeneralRespons?> post1(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? token}) async {
    log('$token');
    try {
      var response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              // 'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));
      log(response.body);
      return generalResponsFromJson(response.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;

      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GeneralRespons?> put(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? token}) async {
    log('$body');
    try {
      var response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));
      log(response.body);
      return generalResponsFromJson(response.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: code ?? false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GeneralRespons?> patch(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? token}) async {
    try {
      var response = await http
          .patch(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));
      return generalResponsFromJson(response.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: code ?? false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GeneralRespons?> delete(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? token}) async {
    try {
      var response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));
      return generalResponsFromJson(response.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;
      final code = err['code'];
      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: code ?? false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<Response> get({required String endpoint, String? token}) async {
    var response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 40));

    return response;
  }

  Future<GeneralRespons?> multPathpost(
      {required String endpoint,
      required List<MapEntry<String, dynamic>> data,
      String? token,
      List<Map<String, dynamic>>? images}) async {
    try {
      var response =
          http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'))
            ..headers.addAll(
              {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );

      for (var entry in data) {
        response.fields[entry.key] = entry.value;
      }
      if (images != null) {
        List<http.MultipartFile> files = images.map((file) {
          return http.MultipartFile.fromBytes(
            'image',
            file["bytes"],
            filename: file["path"],
          );
        }).toList();
        response.files.addAll(files);
      }
      final res = await response.send();
      final resBody = await http.Response.fromStream(res);
      log(resBody.body);
      return generalResponsFromJson(resBody.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;

      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }

  Future<GeneralRespons?> multPathput(
      {required String endpoint,
      required List<MapEntry<String, dynamic>> data,
      String? token,
      List<Map<String, dynamic>>? images}) async {
    try {
      var response =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl$endpoint'))
            ..headers.addAll(
              {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );

      for (var entry in data) {
        response.fields[entry.key] = entry.value;
      }
      if (images != null) {
        List<http.MultipartFile> files = images.map((file) {
          return http.MultipartFile.fromBytes(
            'image',
            file["bytes"],
            filename: file["path"],
          );
        }).toList();
        response.files.addAll(files);
      }
      final res = await response.send();
      final resBody = await http.Response.fromStream(res);
      log(resBody.body);
      return generalResponsFromJson(resBody.body);
    } on TimeoutException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'Request Timeout',
      );
    } on SocketException catch (_) {
      return GeneralRespons(
        success: false,
        message: 'No Internet connection',
      );
    } catch (e) {
      final err = e as Map;

      final message = err['message'];
      final requestErr = err['error'];
      return GeneralRespons(
        success: false,
        message: message ?? requestErr ?? 'Something went wrong $e',
      );
    }
  }
}
