import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/money_format.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../bloc/transaction_list_cubit.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('addTransaction'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          return switch (state) {
            TransactionListLoading() => const Center(child: CircularProgressIndicator()),
            TransactionListReady(:final transactions) => transactions.isEmpty
                ? Center(child: Text('No transactions yet', style: Theme.of(context).textTheme.bodyLarge))
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return _TransactionTile(
                        key: ValueKey(t.id),
                        transaction: t,
                        onDelete: () => context.read<TransactionListCubit>().delete(t.id),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({super.key, required this.transaction, required this.onDelete});

  final domain.Transaction transaction;
  final VoidCallback onDelete;

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    final amount = transaction.amount.minorUnits;
    final subtitle = _formatDate(transaction.occurredAt);
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        title: Text(transaction.title),
        subtitle: Text(subtitle),
        trailing: Text(
          formatMinorUnits(amount, transaction.amount.currencyCode),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: amount < 0 ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
