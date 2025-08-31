// Created by Sultonbek Tulanov on 31-August 2025
// core/services/global_message_bus.dart
import 'dart:async';

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

  static void showError(String message) =>
      _messageController.add(MessageData(message, MessageType.error));

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
 
