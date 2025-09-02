// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_state_cubit.dart';

// splash_screen.dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    final destination = authStatusCubit.state ? '/home/records' : '/login';
    context.go(destination);
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
