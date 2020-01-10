import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wishlist/src/networking/api_exeption%20.dart';
import 'package:wishlist/src/networking/api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/repository/session_repository.dart';

class TodoApiProvider extends ApiProvider {
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

  Future<bool> updateTodo(UpdateTodoRequest updateTodoRequest) async {
    try {
      String firebaseDeviceId = SessionRepository().getFirebaseDeviceId();
      print("firebase id "+ firebaseDeviceId);
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

  Future<bool> updateTodoCategory(int todoId, int category) async {
    try {
      String firebaseDeviceId = SessionRepository().getFirebaseDeviceId();
      await dio.post(baseUrl + "/todo/update/category",
          data: {"id": todoId, "category": category},
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
