// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/di/repository_module.dart';
import 'package:finance_tracker/core/di/usecase_module.dart';
import 'package:finance_tracker/core/service/notificaion/notification_service.dart';
import 'package:finance_tracker/core/service/notificaion/notification_service_impl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import '../config/firebase_options.dart';
import '../service/preferences_service.dart';
import 'bloc_module.dart';

final get = GetIt.instance;

class AppDi {
  AppDi._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: AppFirebaseOptions.currentPlatform);
    await get
        .registerSingleton<NotificationService>(FirebaseNotificationService())
        .initialize();

    await PreferencesService.init();
    RepositoryModule.initialize(get);
    UseCaseModule.initialize(get);
    BlocModule.initialize(get);

    get<NotificationService>().getToken();
  }
}
