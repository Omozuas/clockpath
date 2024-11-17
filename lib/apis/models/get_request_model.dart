// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

GetRequestModel getRequestModelFromJson(String str) =>
    GetRequestModel.fromJson(json.decode(str));

String getRequestModelToJson(GetRequestModel? data) =>
    json.encode(data?.toJson());

class GetRequestModel {
  String? status;
  String message;
  int? statusCode;
  Data? data;

  GetRequestModel({
    this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  factory GetRequestModel.fromJson(Map<String, dynamic> json) =>
      GetRequestModel(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "data": data?.toJson(),
      };

  GetRequestModel copyWith({
    String? status,
    String? message,
    int? statusCode,
    Data? data,
  }) {
    return GetRequestModel(
      status: status ?? this.status,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'GetRequestModel(status: $status, message: $message, statusCode: $statusCode, data: $data)';
  }

  @override
  bool operator ==(covariant GetRequestModel other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        statusCode.hashCode ^
        data.hashCode;
  }
}

class Data {
  List<Datum>? data;
  Pagination? pagination;

  Data({
    this.data,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : null,
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "data": data?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };

  Data copyWith({
    List<Datum>? data,
    Pagination? pagination,
  }) {
    return Data(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  String toString() => 'Data(data: $data, pagination: $pagination)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data) && other.pagination == pagination;
  }

  @override
  int get hashCode => data.hashCode ^ pagination.hashCode;
}

class Datum {
  String? id;
  String? user;
  String? requestType;
  String? reason;
  String? note;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.user,
    this.requestType,
    this.reason,
    this.note,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        user: json["user"],
        requestType: json["requestType"],
        reason: json["reason"],
        note: json["note"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        status: json["status"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "requestType": requestType,
        "reason": reason,
        "note": note,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  Datum copyWith({
    String? id,
    String? user,
    String? requestType,
    String? reason,
    String? note,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      user: user ?? this.user,
      requestType: requestType ?? this.requestType,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  String toString() {
    return 'Datum(id: $id, user: $user, requestType: $requestType, reason: $reason, note: $note, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant Datum other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.requestType == requestType &&
        other.reason == reason &&
        other.note == note &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        requestType.hashCode ^
        reason.hashCode ^
        note.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;

  Pagination({
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
      };

  Pagination copyWith({
    int? currentPage,
    int? totalPages,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  bool operator ==(covariant Pagination other) {
    if (identical(this, other)) return true;

    return other.currentPage == currentPage && other.totalPages == totalPages;
  }

  @override
  int get hashCode => currentPage.hashCode ^ totalPages.hashCode;

  @override
  String toString() =>
      'Pagination(currentPage: $currentPage, totalPages: $totalPages)';
}
