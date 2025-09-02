import 'package:finance_tracker/app.dart';
import 'package:finance_tracker/core/config/firebase_options.dart';
import 'package:finance_tracker/core/config/talker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/app_di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterError.onError = (details) {
    // appTalker?.handle(details.exception, details.stack);
  };
  await Firebase.initializeApp(options: AppFirebaseOptions.currentPlatform);
  await AppDi.initialize();
  initializeDateFormatting();

  runApp(const App());
}
