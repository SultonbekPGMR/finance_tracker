// Created by Sultonbek Tulanov on 08-September 2025

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/feature/auth/data/service/app_lock_service.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/talker.dart';

@injectable
class AppLockCubit extends Cubit<AppLockState> {
  final AppLockService _appLockService;

  AppLockCubit(this._appLockService) : super(AppLockInitial());

  Future<void> checkAppLockStatus() async {
    emit(AppLockLoading());
    
    try {
      final bool hasPin = await _appLockService.hasPin();
      final bool isAppLockEnabled = await _appLockService.isAppLockEnabled();
      appTalker?.debug('AppLockStatus: hasPin=$hasPin, isEnabled=$isAppLockEnabled');
      
      if (!hasPin || !isAppLockEnabled) {
        emit(AppLockDisabled());
        return;
      }
      
      // If app lock is enabled and PIN is set, require authentication
      final bool biometricAvailable = await _appLockService.isBiometricAvailable();
      final bool biometricEnabled = await _appLockService.isBiometricEnabled();

      appTalker?.debug('BiometricStatus: available=$biometricAvailable, enabled=$biometricEnabled');
      emit(AppLockRequired(
        biometricAvailable: biometricAvailable && biometricEnabled,
      ));
    } catch (e) {
      emit(AppLockError(e.toString()));
    }
  }

  Future<void> authenticate(String pin) async {
    emit(AppLockLoading());
    
    try {
      final bool isValidPin = await _appLockService.verifyPin(pin);
      
      if (isValidPin) {
        _appLockService.clearAuthenticationRequired();
        emit(AppLockAuthenticated());
      } else {
        emit(AppLockError('Invalid PIN'));
        
        // Return to required state
        final bool biometricAvailable = await _appLockService.isBiometricAvailable();
        final bool biometricEnabled = await _appLockService.isBiometricEnabled();
        
        emit(AppLockRequired(
          biometricAvailable: biometricAvailable && biometricEnabled,
        ));
      }
    } catch (e) {
      emit(AppLockError(e.toString()));
    }
  }

  Future<void> authenticateWithBiometric() async {
    try {
      appTalker?.debug('Starting biometric authentication');
      final bool success = await _appLockService.authenticateWithBiometric();
      appTalker?.debug('Biometric authentication success: $success');
      
      if (success) {
        _appLockService.clearAuthenticationRequired();
        emit(AppLockAuthenticated());
      } else {
        // Stay in required state if biometric fails
        final bool biometricAvailable = await _appLockService.isBiometricAvailable();
        final bool biometricEnabled = await _appLockService.isBiometricEnabled();
        
        emit(AppLockRequired(
          biometricAvailable: biometricAvailable && biometricEnabled,
        ));
      }
    } catch (e) {
      appTalker?.error('Biometric authentication error: $e');
      emit(AppLockError(e.toString()));
    }
  }

  Future<void> setupPin(String pin) async {
    emit(AppLockLoading());
    
    try {
      await _appLockService.setPin(pin);
      await _appLockService.setAppLockEnabled(true);
      emit(AppLockAuthenticated());
    } catch (e) {
      emit(AppLockError(e.toString()));
    }
  }

  Future<void> requireAuthentication() async {
    _appLockService.requireAuthentication();
    await checkAppLockStatus();
  }

  Future<void> disableAppLock() async {
    try {
      await _appLockService.removePin();
      emit(AppLockDisabled());
    } catch (e) {
      emit(AppLockError(e.toString()));
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _appLockService.setBiometricEnabled(enabled);
      await checkAppLockStatus();
    } catch (e) {
      emit(AppLockError(e.toString()));
    }
  }
}

abstract class AppLockState {}

class AppLockInitial extends AppLockState {}

class AppLockLoading extends AppLockState {}

class AppLockDisabled extends AppLockState {}

class AppLockRequired extends AppLockState {
  final bool biometricAvailable;

  AppLockRequired({required this.biometricAvailable});
}

class AppLockAuthenticated extends AppLockState {}

class AppLockError extends AppLockState {
  final String message;

  AppLockError(this.message);
}