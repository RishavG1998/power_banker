import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/repositories/transaction_repository.dart';
import '../bloc/add_transaction_cubit.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTransactionCubit(context.read<TransactionRepository>()),
      child: const _AddTransactionView(),
    );
  }
}

class _AddTransactionView extends StatelessWidget {
  const _AddTransactionView();

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final d = date.toLocal();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTransactionCubit, AddTransactionState>(
      listenWhen: (a, b) => a.completed != b.completed && b.completed,
      listener: (context, state) {
        context.pop();
      },
      builder: (context, state) {
        final cubit = context.read<AddTransactionCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Add transaction')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                textCapitalization: TextCapitalization.sentences,
                onChanged: cubit.setTitle,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount', hintText: '0.00'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: cubit.setAmountText,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Expense'),
                  Switch(
                    value: !state.isExpense,
                    onChanged: (v) => cubit.setExpense(!v),
                  ),
                  const Text('Income'),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(_formatDate(state.date)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final now = state.date ?? DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      // `showDatePicker` returns the selected day at midnight; keep the existing time-of-day
                      // so transaction ordering remains stable (even though we only display the date).
                      cubit.setDate(DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        now.hour,
                        now.minute,
                        now.second,
                        now.millisecond,
                        now.microsecond,
                      ));
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              if (state.categories.isEmpty)
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Categories'),
                  subtitle: Text('Loading…'),
                )
              else
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: state.categories.any((c) => c.id == state.categoryId)
                      ? state.categoryId
                      : state.categories.first.id,
                  items: [
                    for (final c in state.categories)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (id) => cubit.setCategoryId(id),
                ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.submitting ? null : cubit.submit,
                child: state.submitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
