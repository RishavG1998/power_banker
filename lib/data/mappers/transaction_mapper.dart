import '../../domain/entities/money.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../datasources/local/app_database.dart';

domain.Transaction mapTransactionRow(TransactionRow row) {
  return domain.Transaction(
    id: row.id,
    title: row.title,
    amount: Money(
      minorUnits: row.amountMinor,
      currencyCode: row.currencyCode,
    ),
    occurredAt: row.occurredAt,
    categoryId: row.categoryId,
    note: row.note,
  );
}
