import 'package:dio/dio.dart';

/// Placeholder for future sync / pull from API. All reads go through Drift locally.
class FinanceRemoteDatasource {
  FinanceRemoteDatasource(this._dio);

  final Dio _dio;

  /// Reserved for health check when backend exists.
  Future<Response<dynamic>?> fetchHealth() async {
    try {
      return await _dio.get<dynamic>('/');
    } on DioException {
      rethrow;
    }
  }
}
