import 'dart:convert';

ReminderModel? reminderModelFromJson(String str) =>
    str.isNotEmpty ? ReminderModel.fromJson(json.decode(str)) : null;

String reminderModelToJson(ReminderModel? data) => json.encode(data?.toJson());

class ReminderModel {
  String? status;
  String message;
  int? statusCode;
  Data? data;

  ReminderModel({
    this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
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
}

class Data {
  bool? hasReminders;
  Clock? clockIn;
  Clock? clockOut;
  NextReminders? nextReminders;

  Data({
    this.hasReminders,
    this.clockIn,
    this.clockOut,
    this.nextReminders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        hasReminders: json["hasReminders"],
        clockIn:
            json["clockIn"] != null ? Clock.fromJson(json["clockIn"]) : null,
        clockOut:
            json["clockOut"] != null ? Clock.fromJson(json["clockOut"]) : null,
        nextReminders: json["nextReminders"] != null
            ? NextReminders.fromJson(json["nextReminders"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "hasReminders": hasReminders,
        "clockIn": clockIn?.toJson(),
        "clockOut": clockOut?.toJson(),
        "nextReminders": nextReminders?.toJson(),
      };
}

class Clock {
  bool? shouldRemind;
  String? message;
  String? reminderTime;
  String? shiftTime;

  Clock({
    this.shouldRemind,
    this.message,
    this.reminderTime,
    this.shiftTime,
  });

  factory Clock.fromJson(Map<String, dynamic> json) => Clock(
        shouldRemind: json["shouldRemind"],
        message: json["message"],
        reminderTime: json["reminderTime"],
        shiftTime: json["shiftTime"],
      );

  Map<String, dynamic> toJson() => {
        "shouldRemind": shouldRemind,
        "message": message,
        "reminderTime": reminderTime,
        "shiftTime": shiftTime,
      };
}

class NextReminders {
  String? clockIn;
  String? clockOut;

  NextReminders({
    this.clockIn,
    this.clockOut,
  });

  factory NextReminders.fromJson(Map<String, dynamic> json) => NextReminders(
        clockIn: json["clockIn"],
        clockOut: json["clockOut"],
      );

  Map<String, dynamic> toJson() => {
        "clockIn": clockIn,
        "clockOut": clockOut,
      };
}
