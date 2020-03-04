import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/data/repository/session_repository.dart';

abstract class TodoApiProvider {
  Future<List<TodoResponse>> getTodos();

  Future<bool> addTodo(TodoRequest todoRequest);

  Future<bool> deleteTodo(DeleteTodoRequest deleteTodoRequest);

  Future<bool> updateTodo(UpdateTodoRequest updateTodoRequest);

  factory TodoApiProvider() => _TodoApiProvider();
}

class _TodoApiProvider extends ApiProvider implements TodoApiProvider {
  @override
  Future<List<TodoResponse>> getTodos() async {
    try {
      Response response = await dio.get(baseUrl + "/reports",
          options: Options(contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return List<TodoResponse>.from(
          response.data.map((x) => TodoResponse.fromJson(x)));
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> addTodo(TodoRequest todoRequest) async {
    try {
      String firebaseDeviceId = SessionRepository().getFirebaseDeviceId();
      await dio.post(baseUrl + "/reports/create",
          data: todoRequest.toJson(),
          options: Options(
              headers: {"DeviceId": firebaseDeviceId},
              contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> deleteTodo(DeleteTodoRequest deleteTodoRequest) async {
    try {
      String firebaseDeviceId = SessionRepository().getFirebaseDeviceId();
      await dio.post(baseUrl + "/reports/delete",
          data: deleteTodoRequest.toJson(),
          options: Options(
              headers: {"DeviceId": firebaseDeviceId},
              contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }

  @override
  Future<bool> updateTodo(UpdateTodoRequest updateTodoRequest) async {
    try {
      String firebaseDeviceId = SessionRepository().getFirebaseDeviceId();
      print("firebase id " + firebaseDeviceId);
      await dio.post(baseUrl + "/reports/update",
          data: updateTodoRequest.toJson(),
          options: Options(
              headers: {"DeviceId": firebaseDeviceId},
              contentType: ContentType.parse("application/json")),
          cancelToken: token);
      return true;
    } on DioError catch (e) {
      print("Exception occured: $e");
      throw ApiExeption.fromDioError(e);
    }
  }
}
