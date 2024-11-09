// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

GeneralRespons generalResponsFromJson(String str) =>
    GeneralRespons.fromJson(json.decode(str));

String generalResponsToJson(GeneralRespons data) => json.encode(data.toJson());

class GeneralRespons {
  final bool? success;
  final String message;
  final String? status;
  final int? statuscode;
  dynamic data;
  final String? accessToken;
  final String? refreshToken;

  GeneralRespons({
    this.success,
    required this.message,
    this.status,
    this.statuscode,
    this.data,
    this.accessToken,
    this.refreshToken,
  });

  factory GeneralRespons.fromJson(Map<String, dynamic> map) => GeneralRespons(
        success: map['success'] != null ? map['success'] as bool : null,
        message: map['message'] as String,
        status: map['status'] != null ? map['status'] as String : null,
        statuscode:
            map['status_code'] != null ? map['status_code'] as int : null,
        data: map['data'] as dynamic,
        accessToken:
            map['access_token'] != null ? map['access_token'] as String : null,
        refreshToken: map['refresh_token'] != null
            ? map['refresh_token'] as String
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'status_code': statuscode,
        'data': data,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };

  GeneralRespons copyWith({
    bool? success,
    String? message,
    String? status,
    int? statuscode,
    dynamic data,
    String? accessToken,
    String? refreshToken,
  }) {
    return GeneralRespons(
      success: success ?? this.success,
      message: message ?? this.message,
      status: status ?? this.status,
      statuscode: statuscode ?? this.statuscode,
      data: data ?? this.data,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  bool operator ==(covariant GeneralRespons other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.message == message &&
        other.status == status &&
        other.statuscode == statuscode &&
        other.data == data &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        message.hashCode ^
        status.hashCode ^
        statuscode.hashCode ^
        data.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode;
  }

  @override
  String toString() {
    return 'GeneralRespons(success: $success, message: $message, status: $status, status_code: $statuscode, data: $data, access_token: $accessToken, refresh_token: $refreshToken)';
  }
}
