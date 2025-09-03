// Created by Sultonbek Tulanov on 02-September 2025
// core/services/global_message_bus.dart
import 'dart:async';

import '../../config/talker.dart';
import '../../service/exception_localization_service.dart';

enum MessageType { error, success, warning, info }

class MessageData {
  final String message;
  final MessageType type;

  MessageData(this.message, this.type);
}

class GlobalMessageBus {
  static final StreamController<MessageData> _messageController =
      StreamController<MessageData>.broadcast();

  static Stream<MessageData> get messageStream => _messageController.stream;
  static void showError(Object? error) {
    String message;

    if (error == null) {
      message = ExceptionLocalizationService.getLocalizedMessage(
          Exception('Unknown error')
      );
    } else if (error is String) {
      // Assume string is already localized
      message = error;
    } else if (error is Exception) {
      message = ExceptionLocalizationService.getLocalizedMessage(error);
    } else {
      // Convert any other object to exception
      message = ExceptionLocalizationService.getLocalizedMessage(
          Exception(error.toString())
      );
    }

    _messageController.add(MessageData(message, MessageType.error));
  }

  static void showSuccess(String message) =>
      _messageController.add(MessageData(message, MessageType.success));

  static void showWarning(String message) =>
      _messageController.add(MessageData(message, MessageType.warning));

  static void showInfo(String message) =>
      _messageController.add(MessageData(message, MessageType.info));

  static void dispose() {
    _messageController.close();
  }
}
