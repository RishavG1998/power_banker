import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/app_dependencies.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/dashboard_cubit.dart';
import 'presentation/bloc/transaction_list_cubit.dart';
import 'presentation/router/app_router.dart';

class PowerBankerApp extends StatefulWidget {
  const PowerBankerApp({super.key, required this.deps});

  final AppDependencies deps;

  @override
  State<PowerBankerApp> createState() => _PowerBankerAppState();
}

class _PowerBankerAppState extends State<PowerBankerApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    final deps = widget.deps;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: deps.transactionRepository),
        RepositoryProvider.value(value: deps.dashboardRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => DashboardCubit(deps.dashboardRepository, deps.transactionRepository),
          ),
          BlocProvider(
            create: (_) => TransactionListCubit(deps.transactionRepository),
          ),
        ],
        child: MaterialApp.router(
          title: 'Power Banker',
          theme: buildAppTheme(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
