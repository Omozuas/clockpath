// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

GetWorkModel? getWorkModelFromJson(String str) =>
    GetWorkModel.fromJson(json.decode(str));

String getWorkModelToJson(GetWorkModel? data) => json.encode(data?.toJson());

class GetWorkModel {
  String? status;
  String message;
  int? statusCode;
  GetWorkModelData? data;

  GetWorkModel({
    this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  factory GetWorkModel.fromJson(Map<String, dynamic> json) => GetWorkModel(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] != null
            ? GetWorkModelData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "data": data?.toJson(),
      };
}

class GetWorkModelData {
  DataData? data;

  GetWorkModelData({
    this.data,
  });

  factory GetWorkModelData.fromJson(Map<String, dynamic> json) =>
      GetWorkModelData(
        data: json["data"] != null ? DataData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class DataData {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? perPage;
  List<WorkDay>? workDays;

  DataData({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.perPage,
    this.workDays,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
        perPage: json["perPage"],
        workDays: json["work_days"] != null
            ? List<WorkDay>.from(
                json["work_days"].map((x) => WorkDay.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "perPage": perPage,
        "work_days": workDays?.map((x) => x.toJson()).toList(),
      };
}

class WorkDay {
  String? day;
  String? date;
  Shift? shift;

  WorkDay({
    this.day,
    this.date,
    this.shift,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) => WorkDay(
        day: json["day"],
        date: json["date"],
        shift: json["shift"] != null ? Shift.fromJson(json["shift"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date": date,
        "shift": shift?.toJson(),
      };

  WorkDay copyWith({
    String? day,
    String? date,
    Shift? shift,
  }) {
    return WorkDay(
      day: day ?? this.day,
      date: date ?? this.date,
      shift: shift ?? this.shift,
    );
  }

  @override
  String toString() => 'WorkDay(day: $day, date: $date, shift: $shift)';

  @override
  bool operator ==(covariant WorkDay other) {
    if (identical(this, other)) return true;

    return other.day == day && other.date == date && other.shift == shift;
  }

  @override
  int get hashCode => day.hashCode ^ date.hashCode ^ shift.hashCode;
}

class Shift {
  String? start;
  String? end;

  Shift({
    this.start,
    this.end,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}
