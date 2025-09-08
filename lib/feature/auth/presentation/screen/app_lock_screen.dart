// Created by Sultonbek Tulanov on 08-September 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/auth/presentation/bloc/app_lock_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/config/talker.dart';

class AppLockScreen extends StatefulWidget {
  final bool isSettingPin;
  final String? currentPin;
  final VoidCallback? onAuthenticated;

  const AppLockScreen({
    super.key,
    this.isSettingPin = false,
    this.currentPin,
    this.onAuthenticated,
  });

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen>
    with TickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  String _enteredPin = '';
  String _confirmPin = '';
  bool _isConfirmingPin = false;
  bool _showError = false;
  bool _biometricAvailable = false;
  bool _isBiometricActive = false;
  
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkBiometricAvailability();
  }

  void _initAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      
      setState(() {
        _biometricAvailable = isAvailable && availableBiometrics.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _biometricAvailable = false;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isBiometricActive) return;
    
    setState(() {
      _isBiometricActive = true;
    });

    try {
      await context.read<AppLockCubit>().authenticateWithBiometric();
    } catch (e) {
      // Handle authentication error
      appTalker?.error('Authentication error: $e');
    } finally {
      setState(() {
        _isBiometricActive = false;
      });
    }
  }

  void _onNumberPressed(String number) {
    HapticFeedback.lightImpact();
    
    if (_enteredPin.length >= 4) return;
    
    setState(() {
      _showError = false;
      _enteredPin += number;
    });

    if (_enteredPin.length == 4) {
      // Add a small delay to show the 4th dot before processing
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _handlePinComplete();
        }
      });
    }
  }

  void _handlePinComplete() {
    if (widget.isSettingPin) {
      if (!_isConfirmingPin) {
        setState(() {
          _confirmPin = _enteredPin;
          _enteredPin = '';
          _isConfirmingPin = true;
        });
      } else {
        if (_enteredPin == _confirmPin) {
          context.read<AppLockCubit>().setupPin(_enteredPin);
        } else {
          _showPinError();
          setState(() {
            _enteredPin = '';
            _confirmPin = '';
            _isConfirmingPin = false;
          });
        }
      }
    } else {
      context.read<AppLockCubit>().authenticate(_enteredPin);
    }
  }

  void _showPinError() {
    HapticFeedback.heavyImpact();
    setState(() {
      _showError = true;
      _enteredPin = '';
    });
    
    _shakeController.forward().then((_) {
      _shakeController.reset();
    });
  }

  void _onBackspacePressed() {
    HapticFeedback.lightImpact();
    
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _showError = false;
      });
    }
  }

  String get _getTitle {
    if (widget.isSettingPin) {
      return _isConfirmingPin ? context.l10n.confirmPin : context.l10n.setPinCode;
    }
    return context.l10n.enterPinCode;
  }

  String get _getSubtitle {
    if (widget.isSettingPin) {
      return _isConfirmingPin 
          ? context.l10n.enterPinAgain 
          : context.l10n.createPinMessage;
    }
    return context.l10n.enterPinToAccess;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppLockCubit, AppLockState>(
      listener: (context, state) {
        if (state is AppLockAuthenticated) {
          if (widget.onAuthenticated != null) {
            widget.onAuthenticated!();
          } else {
            context.goNamed('dashboard');
          }
        } else if (state is AppLockError) {
          _showPinError();
        }
      },
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Spacer(flex: 2),
                _buildHeader(),
                const Spacer(),
                AnimatedOpacity(
                  opacity: _isBiometricActive ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedScale(
                    scale: _isBiometricActive ? 0.8 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _buildPinDots(),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: _isBiometricActive ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedScale(
                    scale: _isBiometricActive ? 0.8 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _buildNumericKeypad(),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _getTitle,
          style: context.textTheme.headlineLarge?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _getSubtitle,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        if (_showError) ...[
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Text(
                  widget.isSettingPin ? context.l10n.pinsDoNotMatch : context.l10n.incorrectPin,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPinDots() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final bool isFilled = index < _enteredPin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? (_showError 
                          ? context.colorScheme.error
                          : context.colorScheme.primary)
                      : Colors.transparent,
                  border: Border.all(
                    color: isFilled
                        ? (_showError 
                            ? context.colorScheme.error
                            : context.colorScheme.primary)
                        : context.colorScheme.outline.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

    Widget _buildNumericKeypad() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          _buildKeypadRow(['4', '5', '6']),
          _buildKeypadRow(['7', '8', '9']),
          _buildKeypadRow(['', '0', 'backspace']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        // For the last row, handle biometric button position
        if (numbers.length == 3 && numbers[0] == '' && numbers[1] == '0' && numbers[2] == 'backspace' && number == '') {
          return BlocBuilder<AppLockCubit, AppLockState>(
            builder: (context, state) {
              final showBiometric = state is AppLockRequired && 
                                  state.biometricAvailable && 
                                  !widget.isSettingPin;
              
              appTalker?.debug('Biometric button check: state=${state.runtimeType}, biometricAvailable=${state is AppLockRequired ? (state as AppLockRequired).biometricAvailable : 'N/A'}, isSettingPin=${widget.isSettingPin}, showBiometric=$showBiometric');
              
              if (showBiometric) {
                return _buildBiometricKeypadButton();
              }
              return const SizedBox(width: 80, height: 80);
            },
          );
        }
        return _buildKeypadButton(number);
      }).toList(),
    );
  }

  Widget _buildKeypadButton(String value) {
    if (value.isEmpty) {
      return const SizedBox(width: 80, height: 80);
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: value == 'backspace' ? _onBackspacePressed : () => _onNumberPressed(value),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Center(
              child: value == 'backspace'
                  ? Icon(
                      Icons.backspace_outlined,
                      size: 28,
                      color: context.colorScheme.onSurface,
                    )
                  : Text(
                      value,
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricKeypadButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: _isBiometricActive ? null : _authenticateWithBiometrics,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Icon(
                Icons.fingerprint,
                size: 28,
                color: _isBiometricActive 
                    ? context.colorScheme.primary.withOpacity(0.5)
                    : context.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: _authenticateWithBiometrics,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isBiometricActive)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colorScheme.primary,
                  ),
                )
              else
                Icon(
                  Icons.fingerprint,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              const SizedBox(width: 8),
              Text(
                context.l10n.useBiometric,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}