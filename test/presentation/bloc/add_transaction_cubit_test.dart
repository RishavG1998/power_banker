import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/core/di/app_dependencies.dart';
import 'package:powerbanker/presentation/bloc/add_transaction_cubit.dart';

void main() {
  group('AddTransactionCubit', () {
    late AppDependencies deps;

    setUp(() async {
      deps = await AppDependencies.forMemoryTests();
    });

    tearDown(() async {
      await deps.database.close();
    });

    test('submit sets completed when valid', () async {
      final cubit = AddTransactionCubit(deps.transactionRepository);
      cubit.setTitle('Lunch');
      cubit.setAmountText('12.50');
      cubit.setExpense(true);
      await cubit.submit();
      expect(cubit.state.completed, isTrue);
      await cubit.close();
    });
  });
}
