import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';

class NotificationApiProvider extends ApiProvider {

  Future<bool> registerForPushNotification(String deviceToken,String userId) async {
    try {
      await dio.post(baseUrl + "/notification/register",
          data: { "token": deviceToken, "user_id": userId},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  Future<bool> unregisterFromPushNotification(String deviceToken) async {
    try {
      await dio.post(baseUrl + "/notification/unregister",
          data: { "token": deviceToken },
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  Future<bool> notifyTodo(String title, String message) async {
    try {
      await dio.post(baseUrl + "/reports/notify",
          data: { "title": title, "body": message},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }
}