import 'package:dio/dio.dart';

import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/remote/finance_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../network/dio_client.dart';

/// Holds app-wide singletons created at bootstrap.
class AppDependencies {
  AppDependencies({
    required this.database,
    required this.dio,
    required this.remoteDatasource,
    required this.transactionRepository,
    required this.dashboardRepository,
  });

  final AppDatabase database;
  final Dio dio;
  final FinanceRemoteDatasource remoteDatasource;
  final TransactionRepository transactionRepository;
  final DashboardRepository dashboardRepository;

  static Future<AppDependencies> create() async {
    final database = AppDatabase();
    final dio = createAppDio();
    final remoteDatasource = FinanceRemoteDatasource(dio);
    final transactionRepository = TransactionRepositoryImpl(database);
    final dashboardRepository = DashboardRepositoryImpl(database);
    await transactionRepository.ensureDefaultCategories();
    return AppDependencies(
      database: database,
      dio: dio,
      remoteDatasource: remoteDatasource,
      transactionRepository: transactionRepository,
      dashboardRepository: dashboardRepository,
    );
  }

  /// In-memory Drift for fast unit/widget tests.
  static Future<AppDependencies> forMemoryTests() async {
    final database = AppDatabase.memory();
    final dio = createAppDio();
    final remoteDatasource = FinanceRemoteDatasource(dio);
    final transactionRepository = TransactionRepositoryImpl(database);
    final dashboardRepository = DashboardRepositoryImpl(database);
    await transactionRepository.ensureDefaultCategories();
    return AppDependencies(
      database: database,
      dio: dio,
      remoteDatasource: remoteDatasource,
      transactionRepository: transactionRepository,
      dashboardRepository: dashboardRepository,
    );
  }
}
