import 'package:equatable/equatable.dart';

import 'money.dart';

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.occurredAt,
    this.categoryId,
    this.note,
  });

  final int id;
  final String title;
  final Money amount;
  final DateTime occurredAt;
  final int? categoryId;
  final String? note;

  @override
  List<Object?> get props => [id, title, amount, occurredAt, categoryId, note];
}
