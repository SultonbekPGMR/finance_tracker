// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/feature/auth/presentation/screen/register_screen.dart';
import 'package:finance_tracker/feature/chart/presentation/bloc/chart_cubit.dart';
import 'package:finance_tracker/feature/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:finance_tracker/feature/expense/presentation/bloc/filtered_expenses/filtered_expenses_cubit.dart';
import 'package:finance_tracker/feature/expense/presentation/screen/expenses_by_filter_screen.dart';
import 'package:finance_tracker/feature/home/presentation/home_screen.dart';
import 'package:finance_tracker/feature/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/presentation/screen/login_screen.dart';
import '../../../feature/auth/presentation/screen/splash_screen.dart';
import '../../../feature/expense/data/model/expense_model.dart';
import '../../../feature/expense/presentation/bloc/expenses_bloc.dart';
import '../../../feature/expense/presentation/screen/expense_details_screen.dart';
import '../../../feature/expense/presentation/screen/expenses_screen.dart';
import '../../feature/chart/presentation/screen/chart_screen.dart';
import '../../feature/dashboard/presentation/screen/dashboard_screen.dart';
import '../../feature/expense/data/model/expense_category_model.dart';
import '../../feature/expense/presentation/bloc/expense_details/expense_details_cubit.dart';
import '../di/app_di.dart';

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
      path: '/add-expense',
      name: 'add-expense',
      builder:
          (context, state) => BlocProvider.value(
            value: get<ExpenseDetailsCubit>()..loadCategories(),
            child: const ExpenseDetailsScreen(),
          ),
    ),
    GoRoute(
      path: '/expenses-by-filter',
      name: 'expenses-by-filter',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final month = data['month'] as DateTime;
        final category = data['category'] as ExpenseCategoryModel;

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value:
                  get<FilteredExpensesCubit>()..loadExpenses(month, category),
            ),
            BlocProvider(create: (context) => get<ExpensesBloc>()),
          ],
          child: ExpensesByFilterScreen(
            selectedMonth: month,
            selectedCategory: category,
          ),
        );
      },
    ),
    GoRoute(
      path: '/update-expense',
      name: 'update-expense',
      builder: (context, state) {
        final expense = state.extra as ExpenseModel;
        return BlocProvider(
          create: (context) => get<ExpenseDetailsCubit>()..loadCategories(),
          child: ExpenseDetailsScreen(expense: expense),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/dashboard',
              name: 'dashboard',
              builder:
                  (context, state) => BlocProvider(
                    create: (context) => get<DashboardCubit>(),
                    child: DashboardScreen(),
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home/expenses',
              name: 'expenses',
              builder: (context, state) {
                final month = state.extra is DateTime ? state.extra as DateTime : null;
                return BlocProvider.value(
                  value: get<ExpensesBloc>()..add(LoadExpensesEvent(month: month)),
                  child: ExpensesScreen(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/charts',
              name: 'charts',
              builder:
                  (context, state) => BlocProvider(
                    create: (context) => get<ChartCubit>(),
                    child: ChartScreen(),
                  ),
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
