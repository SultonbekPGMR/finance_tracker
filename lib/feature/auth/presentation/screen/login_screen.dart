// Created by Sultonbek Tulanov on 30-August 2025
import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:finance_tracker/feature/auth/presentation/screen/auth_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widget/app_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: InkWell(
                    onTap:
                        () => context.read<AuthBloc>().add(
                          SignInEvent('sultonbek@gmail.com', '123456'),
                        ),
                    onLongPress:
                        () => context.read<AuthBloc>().add(
                          SignInEvent('s@gmail.com', '123456'),
                        ),
                    child: Text(
                      context.l10n.welcomeBack,
                      style: context.textTheme.headlineLarge,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                AppTextField(
                  type: AppTextFieldType.email,
                  controller: emailController,
                  hint: context.l10n.emailHint,
                ),

                AppTextField(
                  type: AppTextFieldType.password,
                  controller: passwordController,
                  hint: context.l10n.passwordHint,
                ),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () => _showForgotPasswordDialog(context),
                      child: Text(
                        context.l10n.forgotPassword,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 50),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                context.read<AuthBloc>().add(
                                  SignInEvent(
                                    emailController.text,
                                    passwordController.text,
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        fixedSize: Size(context.screenWidth / 1.5, 50),
                        backgroundColor: context.colorScheme.primary,
                      ),
                      child: Builder(
                        builder: (context) {
                          return isLoading
                              ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: context.colorScheme.primary,
                                ),
                              )
                              : Text(
                                context.l10n.signIn,
                                style: context.textTheme.titleLarge?.copyWith(
                                  color: context.colorScheme.onPrimary,
                                ),
                              );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '${context.l10n.dontHaveAccount} ',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: context.l10n.signUp,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  context.goNamed('register');
                                },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetEmailSent) {
              context.pop();
              GlobalMessageBus.showSuccess(context.l10n.passwordResetEmailSent);
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              context.l10n.forgotPasswordTitle,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.forgotPasswordMessage,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    type: AppTextFieldType.email,
                    controller: emailController,
                    hint: context.l10n.emailHint,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  context.l10n.cancel,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthPasswordResetLoading;
                  return ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  PasswordResetEvent(
                                    emailController.text.trim(),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: context.colorScheme.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              context.l10n.sendResetLink,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
