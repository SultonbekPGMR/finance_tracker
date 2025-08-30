// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/di/app_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/home_screen.dart';
import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return state.isSignedIn ? const HomeScreen() : const LoginScreen();
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
