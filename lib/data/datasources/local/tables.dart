import 'package:drift/drift.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer().nullable()();
}

@DataClassName('TransactionRow')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text().withLength(max: 8)();
  DateTimeColumn get occurredAt => dateTime()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get note => text().nullable()();
}
