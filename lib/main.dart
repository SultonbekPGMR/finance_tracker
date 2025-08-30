import 'package:finance_tracker/app.dart';
import 'package:finance_tracker/core/config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/app_di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: AppFirebaseOptions.currentPlatform);
  AppDi.initialize();


  runApp(const App());
}
