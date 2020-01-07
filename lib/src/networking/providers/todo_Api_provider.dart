import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';

class TodoApiProvider extends ApiProvider {
  Future<List<TodoResponse>> getTodos() async {
    try {
      Response response = await dio.get(baseUrl + "/reports",
          options: Options(
              contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return List<TodoResponse>.from(response.data.map((x) => TodoResponse.fromJson(x)));
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

}