// Created by Sultonbek Tulanov on 08-September 2025

import 'package:finance_tracker/feature/auth/presentation/bloc/app_lock_cubit.dart';
import 'package:finance_tracker/feature/auth/presentation/screen/app_lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppLockWrapper extends StatefulWidget {
  final Widget child;

  const AppLockWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<AppLockWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Check app lock status on init
    context.read<AppLockCubit>().checkAppLockStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Require authentication when app becomes inactive or paused
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive) {
      context.read<AppLockCubit>().requireAuthentication();
    }
    
    // Check app lock status when app resumes
    if (state == AppLifecycleState.resumed) {
      context.read<AppLockCubit>().checkAppLockStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockCubit, AppLockState>(
      listener: (context, state) {
        if (state is AppLockAuthenticated) {
          // If we came from app lock screen, go back to previous screen
          if (ModalRoute.of(context)?.settings.name == '/app-lock') {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        if (state is AppLockRequired) {
          return AppLockScreen(
            isSettingPin: false,
            onAuthenticated: () {
              context.read<AppLockCubit>().checkAppLockStatus();
            },
          );
        }
        
        return widget.child;
      },
    );
  }
}