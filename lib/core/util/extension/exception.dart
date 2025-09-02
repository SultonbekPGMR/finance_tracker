// Created by Sultonbek Tulanov on 02-September 2025

import '../service/exception_localization_service.dart';

extension ExceptionExtension on Exception {
  /// Get localized error message for this exception
  String get localizedMessage {
    return ExceptionLocalizationService.getLocalizedMessage(this);
  }
}
