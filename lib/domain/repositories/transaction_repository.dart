import '../entities/category.dart';
import '../entities/transaction.dart' as domain;

abstract class TransactionRepository {
  Stream<List<domain.Transaction>> watchTransactions();

  Stream<List<Category>> watchCategories();

  Future<int> addTransaction({
    required String title,
    required int amountMinorUnits,
    required String currencyCode,
    required DateTime occurredAt,
    int? categoryId,
    String? note,
  });

  Future<void> updateTransaction(domain.Transaction transaction);

  Future<void> deleteTransaction(int id);

  Future<void> ensureDefaultCategories();
}
