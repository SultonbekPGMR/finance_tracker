// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/auth/presentation/bloc/app_lock_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/talker.dart';
import '../../../../core/navigation/notificaion_action_handler.dart';
import '../bloc/auth_state_cubit.dart';

// splash_screen.dart
class SplashScreen extends StatefulWidget {
  final String? initialPayload;

  const SplashScreen(this.initialPayload, {super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final authStatusCubit = context.read<AuthStatusCubit>();
    final appLockCubit = context.read<AppLockCubit>();
    
    // Check authentication first
    if (!authStatusCubit.state) {
      context.goNamed('login');
      return;
    }
    
    // Check app lock status
    await appLockCubit.checkAppLockStatus();
    final appLockState = appLockCubit.state;

    if (!mounted) return;
    appTalker?.debug('AppLockState: $appLockState');
    if (appLockState is AppLockRequired) {
      context.goNamed('app-lock');
    } else {

      context.goNamed('dashboard');
      NotificationActionHandler.handlePendingNavigation(widget.initialPayload);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            Text(
              'Personal Finance Tracker',
              style: context.textTheme.headlineLarge,
            ),
            Spacer(flex: 3),
            CircularProgressIndicator(),
            Spacer(),

          ],
        ),
      ),
    );
  }
}
