import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/local/app_database.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<DashboardSummary> watchSummary({
    required DateTime from,
    required DateTime to,
  }) {
    return _db.select(_db.transactions).watch().map((rows) {
      final filtered =
          rows.where((r) {
            final d = r.occurredAt;
            return !d.isBefore(from) && !d.isAfter(to);
          }).toList();

      var currency = 'INR';
      var income = 0;
      var expenseAbs = 0;
      final byCategory = <int, int>{};

      for (final r in filtered) {
        currency = r.currencyCode;
        final a = r.amountMinor;
        if (a > 0) {
          income += a;
        } else if (a < 0) {
          final abs = -a;
          expenseAbs += abs;
          final cid = r.categoryId;
          if (cid != null) {
            byCategory[cid] = (byCategory[cid] ?? 0) + abs;
          }
        }
      }

      return DashboardSummary(
        totalIncomeMinor: income,
        totalExpenseMinor: expenseAbs,
        currencyCode: currency,
        categoryExpenseMinor: byCategory,
      );
    });
  }
}
