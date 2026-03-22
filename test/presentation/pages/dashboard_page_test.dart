import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/core/di/app_dependencies.dart';
import 'package:powerbanker/presentation/bloc/dashboard_cubit.dart';
import 'package:powerbanker/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('DashboardPage shows KPI labels', (WidgetTester tester) async {
    final deps = await AppDependencies.forMemoryTests();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => DashboardCubit(deps.dashboardRepository, deps.transactionRepository),
          child: const DashboardPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await deps.database.close();
  });
}
