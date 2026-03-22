import 'package:equatable/equatable.dart';

/// Aggregates for dashboard charts (period totals, category breakdown).
class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.totalIncomeMinor,
    required this.totalExpenseMinor,
    required this.currencyCode,
    required this.categoryExpenseMinor,
  });

  final int totalIncomeMinor;
  final int totalExpenseMinor;
  final String currencyCode;
  /// categoryId -> expense minor units (only expenses, positive values).
  final Map<int, int> categoryExpenseMinor;

  @override
  List<Object?> get props => [totalIncomeMinor, totalExpenseMinor, currencyCode, categoryExpenseMinor];
}
