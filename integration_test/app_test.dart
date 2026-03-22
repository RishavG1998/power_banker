import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:powerbanker/app.dart';
import 'package:powerbanker/core/di/app_dependencies.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('open transactions and see list or empty state', (WidgetTester tester) async {
    final deps = await AppDependencies.forMemoryTests();
    addTearDown(() async => deps.database.close());

    await tester.pumpWidget(PowerBankerApp(deps: deps));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();

    expect(find.text('Transactions'), findsWidgets);
  });
}
