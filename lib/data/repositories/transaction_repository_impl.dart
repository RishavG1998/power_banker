import 'package:drift/drift.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart' as tx;
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/app_database.dart';
import '../mappers/category_mapper.dart';
import '../mappers/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<tx.Transaction>> watchTransactions() {
    final q = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    return q.watch().map((rows) => rows.map(mapTransactionRow).toList());
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _db.select(_db.categories).watch().map(
          (rows) => rows.map(mapCategoryRow).toList(),
        );
  }

  @override
  Future<int> addTransaction({
    required String title,
    required int amountMinorUnits,
    required String currencyCode,
    required DateTime occurredAt,
    int? categoryId,
    String? note,
  }) async {
    return _db.into(_db.transactions).insert(
          TransactionsCompanion.insert(
            title: title,
            amountMinor: amountMinorUnits,
            currencyCode: currencyCode,
            occurredAt: occurredAt,
            categoryId: Value(categoryId),
            note: Value(note),
          ),
        );
  }

  @override
  Future<void> updateTransaction(tx.Transaction transaction) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(transaction.id)))
        .write(
      TransactionsCompanion(
        title: Value(transaction.title),
        amountMinor: Value(transaction.amount.minorUnits),
        currencyCode: Value(transaction.amount.currencyCode),
        occurredAt: Value(transaction.occurredAt),
        categoryId: Value(transaction.categoryId),
        note: Value(transaction.note),
      ),
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> ensureDefaultCategories() async {
    final existing = await _db.select(_db.categories).get();
    if (existing.isNotEmpty) return;

    await _db.batch((b) {
      b.insert(
        _db.categories,
        CategoriesCompanion.insert(name: 'Food', colorValue: const Value(0xFFE57373)),
      );
      b.insert(
        _db.categories,
        CategoriesCompanion.insert(name: 'Transport', colorValue: const Value(0xFF64B5F6)),
      );
      b.insert(
        _db.categories,
        CategoriesCompanion.insert(name: 'Bills', colorValue: const Value(0xFFFFB74D)),
      );
      b.insert(
        _db.categories,
        CategoriesCompanion.insert(name: 'Income', colorValue: const Value(0xFF81C784)),
      );
    });
  }
}
