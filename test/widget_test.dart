import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/app.dart';
import 'package:powerbanker/core/di/app_dependencies.dart';

void main() {
  testWidgets('App loads dashboard shell', (WidgetTester tester) async {
    final deps = await AppDependencies.forMemoryTests();

    await tester.pumpWidget(PowerBankerApp(deps: deps));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await deps.database.close();
  });
}
