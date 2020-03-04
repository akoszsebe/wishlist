import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';

abstract class NotificationApiProvider {
  Future<bool> registerForPushNotification(String deviceToken, String userId);

  Future<bool> unregisterFromPushNotification(String deviceToken);

  Future<bool> notifyTodo(String title, String message);

  Future<bool> sendAlarm(String title, int when);

  factory NotificationApiProvider() => _NotificationApiProvider();
}

class _NotificationApiProvider extends ApiProvider
    implements NotificationApiProvider {
  @override
  Future<bool> registerForPushNotification(
      String deviceToken, String userId) async {
    try {
      await dio.post(baseUrl + "/notification/register",
          data: {"token": deviceToken, "user_id": userId},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> unregisterFromPushNotification(String deviceToken) async {
    try {
      await dio.post(baseUrl + "/notification/unregister",
          data: {"token": deviceToken},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> notifyTodo(String title, String message) async {
    try {
      await dio.post(baseUrl + "/reports/notify",
          data: {"title": title, "body": message},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> sendAlarm(String title, int when) async {
    try {
      await dio.post(baseUrl + "/reports/sendalarm",
          data: {"title": title, "when": when},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }
}
