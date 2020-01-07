import 'package:dio/dio.dart';

abstract class ApiProvider {
  final String baseUrl = "https://wishlistbackend.herokuapp.com/api";
  final Dio dio = Dio();
  final CancelToken token = new CancelToken();

  ApiProvider() {
    dio.interceptors.add(LogInterceptor(responseBody: true,requestBody: true));
  }


  void cancelRequest(){
    token.cancel("cancelled");
  }
}