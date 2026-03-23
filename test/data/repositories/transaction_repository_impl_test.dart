import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/core/di/app_dependencies.dart';

void main() {
  group('TransactionRepositoryImpl', () {
    late AppDependencies deps;

    setUp(() async {
      deps = await AppDependencies.forMemoryTests();
    });

    tearDown(() async {
      await deps.database.close();
    });

    test('add and watch transactions', () async {
      final repo = deps.transactionRepository;
      await repo.addTransaction(
        title: 'Coffee',
        amountMinorUnits: -350,
        currencyCode: 'INR',
        occurredAt: DateTime(2025, 1, 15),
        categoryId: (await repo.watchCategories().first).first.id,
      );

      final list = await repo.watchTransactions().first;
      expect(list, isNotEmpty);
      expect(list.first.title, 'Coffee');
      expect(list.first.amount.minorUnits, -350);
    });
  });
}
