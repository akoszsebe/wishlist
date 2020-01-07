import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
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

  Future<bool> addTodo(TodoRequest todoRequest) async {
    try {
      Response response = await dio.post(baseUrl + "/reports/create",
          data: todoRequest.toJson(),
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

}