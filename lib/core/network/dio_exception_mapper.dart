import 'package:dio/dio.dart';

/// Maps [DioException] to a stable message for UI; extend with typed failures later.
String mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Request timed out. Check your connection.';
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      return code != null ? 'Server error ($code)' : 'Server error';
    case DioExceptionType.cancel:
      return 'Request cancelled';
    case DioExceptionType.connectionError:
      return 'No internet connection';
    case DioExceptionType.badCertificate:
      return 'Invalid certificate';
    case DioExceptionType.unknown:
      return e.message ?? 'Network error';
  }
}
