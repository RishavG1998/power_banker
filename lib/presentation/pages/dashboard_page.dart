import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/money_format.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () {
                  final c = context.read<DashboardCubit>();
                  final s = c.state;
                  if (s is DashboardLoaded) {
                    final m = DateTime(s.rangeFrom.year, s.rangeFrom.month - 1);
                    c.setMonth(m);
                  }
                },
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () {
                  final c = context.read<DashboardCubit>();
                  final s = c.state;
                  if (s is DashboardLoaded) {
                    final m = DateTime(s.rangeFrom.year, s.rangeFrom.month + 1);
                    c.setMonth(m);
                  }
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          body: switch (state) {
            DashboardLoading() => const Center(child: CircularProgressIndicator()),
            DashboardLoaded(:final summary, :final categories, :final rangeFrom) => _DashboardBody(
                summary: summary,
                categories: categories,
                monthLabel: '${rangeFrom.year}-${rangeFrom.month.toString().padLeft(2, '0')}',
              ),
          },
        );
      },
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.summary,
    required this.categories,
    required this.monthLabel,
  });

  final DashboardSummary summary;
  final List<Category> categories;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Period: $monthLabel', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Income',
                value: formatMinorUnits(summary.totalIncomeMinor, summary.currencyCode),
                color: scheme.primaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                label: 'Expenses',
                value: formatMinorUnits(summary.totalExpenseMinor, summary.currencyCode),
                color: scheme.errorContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Spending by category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: summary.categoryExpenseMinor.isEmpty
                ? Center(
                    key: const ValueKey('empty'),
                    child: Text('No expenses in this range', style: Theme.of(context).textTheme.bodyLarge),
                  )
                : _CategoryPie(
                    key: ValueKey('${summary.totalExpenseMinor}_${summary.categoryExpenseMinor.length}'),
                    summary: summary,
                    categories: categories,
                  ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _CategoryPie extends StatelessWidget {
  const _CategoryPie({super.key, required this.summary, required this.categories});

  final DashboardSummary summary;
  final List<Category> categories;

  Color _colorFor(int categoryId) {
    for (final c in categories) {
      if (c.id == categoryId) return Color(c.colorValue ?? 0xFF2196F3);
    }
    return const Color(0xFF2196F3);
  }

  String _nameFor(int categoryId) {
    for (final c in categories) {
      if (c.id == categoryId) return c.name;
    }
    return 'Category $categoryId';
  }

  @override
  Widget build(BuildContext context) {
    final entries = summary.categoryExpenseMinor.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<int>(0, (a, b) => a + b.value);
    if (total == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: List.generate(entries.length, (i) {
                final e = entries[i];
                final pct = e.value / total;
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: '${(pct * 100).toStringAsFixed(0)}%',
                  color: _colorFor(e.key),
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final e in entries)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: _colorFor(e.key), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('${_nameFor(e.key)} · ${formatMinorUnits(e.value, summary.currencyCode)}'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
