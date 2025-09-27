import 'package:finance_tracker/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/app_di.dart';
import 'core/navigation/notificaion_action_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeUi();
  await AppDi.initialize();
  await NotificationActionHandler.checkNotificationLaunchDetails();
  runApp(const App());
}

Future<void> initializeUi() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting();
}
