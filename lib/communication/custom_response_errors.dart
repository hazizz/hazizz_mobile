import 'package:dio/dio.dart';

DioError noConnectionError = DioError(type: DioErrorType.DEFAULT, error: "No internet connection", message: "No internet connection");