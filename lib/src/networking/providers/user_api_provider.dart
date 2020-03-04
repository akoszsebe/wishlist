import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/data/model/user_model.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';

abstract class UserApiProvider {
  Future<bool> registerUser(UserModel user);

  Future<bool> unregisterUser(String userId);

  factory UserApiProvider() => _UserApiProvider();
}

class _UserApiProvider extends ApiProvider implements UserApiProvider {
  @override
  Future<bool> registerUser(UserModel user) async {
    try {
      await dio.post(baseUrl + "/user/create",
          data: user.toJson(),
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> unregisterUser(String userId) async {
    try {
      await dio.post(baseUrl + "/user/delete",
          data: {"user_id": userId},
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }
}
