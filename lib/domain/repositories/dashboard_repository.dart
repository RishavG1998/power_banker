import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  /// Reactive summary for [from]..[to] (inclusive day bounds in local time).
  Stream<DashboardSummary> watchSummary({
    required DateTime from,
    required DateTime to,
  });
}
