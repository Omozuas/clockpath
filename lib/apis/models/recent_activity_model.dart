// To parse this JSON data, do
//
//     final RecentActivityModel = RecentActivityModelFromJson(jsonString);

import 'dart:convert';

RecentActivityModel recentActivityModelFromJson(String str) =>
    RecentActivityModel.fromJson(json.decode(str));

String recentActivityModelToJson(RecentActivityModel data) =>
    json.encode(data.toJson());

class RecentActivityModel {
  String? status;
  String message;
  Data? data;

  RecentActivityModel({this.data, this.status, required this.message});

  factory RecentActivityModel.fromJson(Map<String, dynamic> map) =>
      RecentActivityModel(
        data: map["data"] != null ? Data.fromJson(map["data"]) : null,
        message: map['message'] as String,
        status: map['status'] != null ? map['status'] as String : null,
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        'message': message,
        'status': status,
      };
}

class Data {
  List<Result>? results;
  Pagination? pagination;

  Data({
    this.results,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"] != null
            ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
            : null,
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "results": results?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };
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
}

class Result {
  String? date;
  String? clockInTime;
  String? clockOutTime;
  String? status;
  double? hoursWorked;

  Result({
    this.date,
    this.clockInTime,
    this.clockOutTime,
    this.status,
    this.hoursWorked,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        date: json["date"] as String?,
        clockInTime: json["clockInTime"] as String?,
        clockOutTime: json["clockOutTime"] as String?,
        status: json["status"] as String?,
        hoursWorked: json["hoursWorked"] != null
            ? (json["hoursWorked"] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "clockInTime": clockInTime,
        "clockOutTime": clockOutTime,
        "status": status,
        "hoursWorked": hoursWorked,
      };
}
