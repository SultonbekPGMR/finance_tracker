// Created by Sultonbek Tulanov on 08-September 2025

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:finance_tracker/feature/auth/data/service/app_lock_service.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppLockService)
class AppLockServiceImpl implements AppLockService {
  static const String _boxName = 'app_lock_box';
  static const String _pinKey = 'app_pin';
  static const String _appLockEnabledKey = 'app_lock_enabled';
  static const String _biometricEnabledKey = 'biometric_enabled';
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _requiresAuthentication = false;
  
  Box<dynamic>? _box;

  Future<Box<dynamic>> get box async {
    return _box ??= await Hive.openBox(_boxName);
  }

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<bool> hasPin() async {
    final box = await this.box;
    final hashedPin = box.get(_pinKey);
    return hashedPin != null && hashedPin.toString().isNotEmpty;
  }

  @override
  Future<void> setPin(String pin) async {
    final box = await this.box;
    final hashedPin = _hashPin(pin);
    await box.put(_pinKey, hashedPin);
    
    // When PIN is set, require authentication
    _requiresAuthentication = true;
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final box = await this.box;
    final storedHashedPin = box.get(_pinKey);
    if (storedHashedPin == null) return false;
    
    final hashedInputPin = _hashPin(pin);
    return hashedInputPin == storedHashedPin;
  }

  @override
  Future<void> removePin() async {
    final box = await this.box;
    await box.delete(_pinKey);
    await setAppLockEnabled(false);
    await setBiometricEnabled(false);
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();
      return isAvailable && availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometric() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      final bool isEnabled = await isBiometricEnabled();
      
      print('Debug: Biometric available: $isAvailable, enabled: $isEnabled');
      
      if (!isAvailable || !isEnabled) return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      print('Debug: Biometric authentication result: $didAuthenticate');
      return didAuthenticate;
    } catch (e) {
      print('Debug: Biometric authentication error: $e');
      return false;
    }
  }

  @override
  Future<void> setAppLockEnabled(bool enabled) async {
    final box = await this.box;
    await box.put(_appLockEnabledKey, enabled);
  }

  @override
  Future<bool> isAppLockEnabled() async {
    final box = await this.box;
    return box.get(_appLockEnabledKey, defaultValue: false);
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    final box = await this.box;
    await box.put(_biometricEnabledKey, enabled);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final box = await this.box;
    return box.get(_biometricEnabledKey, defaultValue: false);
  }

  @override
  void requireAuthentication() {
    _requiresAuthentication = true;
  }

  @override
  bool get requiresAuthentication => _requiresAuthentication;

  @override
  void clearAuthenticationRequired() {
    _requiresAuthentication = false;
  }

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}