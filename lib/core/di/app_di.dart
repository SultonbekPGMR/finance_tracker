// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/service/notificaion/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';

import '../config/firebase_options.dart';
import '../service/preferences_service.dart';
import 'injection.dart';

class AppDi {
  AppDi._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: AppFirebaseOptions.currentPlatform);
    
    // Configure injectable dependencies - this now handles ALL DI registration
    configureDependencies();
    
    // Initialize notification service
    await getIt<NotificationService>().initialize();

    await PreferencesService.init();

    getIt<NotificationService>().getToken();
  }
}
