import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_exception_mapper.dart';

/// Creates a singleton-style [Dio] with interceptors. Base URL can point to a stub until API exists.
Dio createAppDio({String? baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://api.example.invalid/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        // Normalize for logging / future Failure types
        if (kDebugMode) {
          debugPrint('[Dio] ${error.requestOptions.uri} → ${mapDioException(error)}');
        }
        handler.next(error);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );
  }

  return dio;
}
