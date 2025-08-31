// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';

enum AppTextFieldType {
  text,
  email,
  phoneNumber,
  password,
  amount,
  name,
  number,
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.onTextChange,
    this.type = AppTextFieldType.text,
    this.textInputAction = TextInputAction.next,
    this.paddingBottom = 20.0,
    this.enabled = true,
  });
  final String hint;
  final AppTextFieldType type;
  final TextInputAction textInputAction;
  final double paddingBottom;
  final bool enabled;
  final void Function(String)? onTextChange;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isEmpty = true;
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    isEmpty = widget.controller.text.isEmpty;

    widget.controller.addListener(() {
      setState(() {
        isEmpty = widget.controller.text.isEmpty;
      });
      widget.onTextChange?.call(widget.controller.text);
    });
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.phoneNumber:
        return TextInputType.phone;
      case AppTextFieldType.amount:
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.name:
        return TextInputType.name;
      case AppTextFieldType.text:
      case AppTextFieldType.password:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    // Define colors based on theme
    final textColor = widget.enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final hintColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

    final borderColor = colorScheme.outline.withValues(alpha: 0.5);
    final focusedBorderColor = colorScheme.primary;
    final disabledBorderColor = colorScheme.outline.withValues(alpha: 0.12);

    final iconColor = widget.enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface.withValues(alpha: 0.38);

    return Padding(
      padding: EdgeInsets.only(bottom: widget.paddingBottom),
      child: TextField(
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        keyboardType: _getKeyboardType(),
        obscureText: widget.type == AppTextFieldType.password && isObscured,
        enabled: widget.enabled,
        style: textTheme.bodyLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: hintColor,
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: disabledBorderColor,
              width: 0.5,
            ),
          ),
          suffixIcon: _buildSuffixIcon(iconColor),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(Color iconColor) {
    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: iconColor,
        ),
        onPressed: () {
          setState(() {
            isObscured = !isObscured;
          });
        },
      );
    } else if (!isEmpty && widget.enabled) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          color: iconColor,
        ),
        onPressed: () {
          widget.controller.clear();
          widget.onTextChange?.call("");
        },
      );
    }
    return null;
  }
}

