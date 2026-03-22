import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/add_transaction_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/settings_page.dart';
import '../pages/transaction_list_page.dart';
import '../widgets/app_shell.dart';

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

GoRouter createAppRouter({List<NavigatorObserver>? observers}) {
  return GoRouter(
    initialLocation: '/',
    observers: observers,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            pageBuilder: (context, state) => _fadePage(
              key: const ValueKey('dashboard'),
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            pageBuilder: (context, state) => _fadePage(
              key: const ValueKey('transactions'),
              child: const TransactionListPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addTransaction',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: const ValueKey('addTransaction'),
                  child: const AddTransactionPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final offset = Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                    return SlideTransition(position: offset, child: FadeTransition(opacity: animation, child: child));
                  },
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => _fadePage(
              key: const ValueKey('settings'),
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
