import 'package:dio/dio.dart';

class ApiExeption implements Exception {
  String message;

  ApiExeption([this.message = ""]);

  ApiExeption.fromDioError(DioError e) {
    if (e.response != null) if (e.response.data != null) {
      message = e.response.data["message"];
    } else {
      message = e.message;
    }
  }

  String toString() => "ApiExeption: $message";
}