// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/feature/auth/presentation/screen/register_screen.dart';
import 'package:finance_tracker/feature/home/presentation/home_screen.dart';
import 'package:finance_tracker/feature/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/presentation/screen/login_screen.dart';
import '../../../feature/auth/presentation/screen/splash_screen.dart';
import '../../../feature/expense/presentation/screen/add_expense_screen.dart';
import '../../../feature/expense/presentation/screen/expense_screen.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    routes: _routes,
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Page not found: ${state.matchedLocation}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/splash'),
                  child: Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );

  static final List<RouteBase> _routes = [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/home/add-expense',
      name: 'add-expense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home/records',
              name: 'records',
              builder: (context, state) => ExpensesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/charts',
              name: 'charts',
              builder: (context, state) => Container(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/reports',
              name: 'reports',
              builder: (context, state) => Container(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/profile',
              name: 'profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ];
}
