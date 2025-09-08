// Created by Sultonbek Tulanov on 08-September 2025

import 'package:local_auth/local_auth.dart';

abstract class AppLockService {
  Future<bool> hasPin();
  Future<void> setPin(String pin);
  Future<bool> verifyPin(String pin);
  Future<void> removePin();
  
  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithBiometric();
  
  Future<void> setAppLockEnabled(bool enabled);
  Future<bool> isAppLockEnabled();
  
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
  
  void requireAuthentication();
  bool get requiresAuthentication;
  void clearAuthenticationRequired();
}