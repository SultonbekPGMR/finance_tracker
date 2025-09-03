// Created by Sultonbek Tulanov on 30-August 2025

import 'dart:async';

import 'package:finance_tracker/core/config/talker.dart';
import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/app_di.dart';
import 'core/l10n/generated/l10n.dart';
import 'core/navigation/app_router.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/service/message_service.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/bloc/auth_state_cubit.dart';
import 'feature/profile/presentation/bloc/profile_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription<MessageData> _messageSubscription;

  @override
  void initState() {
    super.initState();

    _messageSubscription = GlobalMessageBus.messageStream.listen((messageData) {
      appTalker?.log(messageData.message);
      switch (messageData.type) {
        case MessageType.error:
          MessageService.showError(messageData.message);
          break;
        case MessageType.success:
          MessageService.showSuccess(messageData.message);
          break;
        case MessageType.warning:
          MessageService.showWarning(messageData.message);
          break;
        case MessageType.info:
          MessageService.showInfo(messageData.message);
          break;
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    GlobalMessageBus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => get<AuthStatusCubit>()),
        BlocProvider(create: (context) => get<AuthBloc>()),
        BlocProvider(create: (context) => get<ProfileCubit>()..loadProfile()),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;
          Locale locale = Locale('en', 'US');

          if (state is ProfileLoaded) {
            themeMode = state.preferences.appTheme;
            locale = state.preferences.appLocale;
          } else if (state is ProfileUpdating) {
            themeMode = state.preferences.appTheme;
            locale = state.preferences.appLocale;
          }

          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Finance Tracker',
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            locale: locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('uz', 'UZ')],
          );
        },
      ),
    );
  }
}
