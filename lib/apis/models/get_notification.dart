import 'dart:convert';

NotificationModel? notificationModelFromJson(String str) =>
    str.isNotEmpty ? NotificationModel.fromJson(json.decode(str)) : null;

String? notificationModelToJson(NotificationModel? data) =>
    data != null ? json.encode(data.toJson()) : null;

class NotificationModel {
  String? status;
  String message;
  int? statusCode;
  Data? data;

  NotificationModel({
    this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
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
  Response? response;

  Data({
    this.response,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        response: json["response"] != null
            ? Response.fromJson(json["response"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
      };
}

class Response {
  List<Notification>? notifications;
  Pagination? pagination;

  Response({
    this.notifications,
    this.pagination,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        notifications: json["notifications"] != null
            ? List<Notification>.from(
                json["notifications"].map((x) => Notification.fromJson(x)))
            : null,
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "notifications": notifications?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };
}

class Notification {
  String? type;
  String? status;
  String? message;
  String? time;
  String? requestType;
  DateTime? createdAt;

  Notification({
    this.type,
    this.status,
    this.message,
    this.time,
    this.requestType,
    this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        type: json["type"],
        status: json["status"],
        message: json["message"],
        time: json["time"],
        requestType: json["requestType"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
        "message": message,
        "time": time,
        "requestType": requestType,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;
  dynamic nextPage;
  dynamic prevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
        itemsPerPage: json["itemsPerPage"],
        hasNextPage: json["hasNextPage"],
        hasPrevPage: json["hasPrevPage"],
        nextPage: json["nextPage"],
        prevPage: json["prevPage"],
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "itemsPerPage": itemsPerPage,
        "hasNextPage": hasNextPage,
        "hasPrevPage": hasPrevPage,
        "nextPage": nextPage,
        "prevPage": prevPage,
      };
}
