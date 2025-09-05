// Created by Sultonbek Tulanov on 31-August 2025
// core/widgets/auth_screen_wrapper.dart
import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/service/exception_localization_service.dart';
import '../bloc/auth_bloc.dart';

class AuthScreenWrapper extends StatelessWidget {
  final Widget child;

  const AuthScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ExceptionLocalizationService.getLocalizedMessage(
                  state.exception,
                ),
              ),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
        if (state is AuthSuccess) {
          context.go('dashboard');
        }
      },
      child: child,
    );
  }
}
