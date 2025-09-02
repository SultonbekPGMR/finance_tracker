// Created by Sultonbek Tulanov on 01-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/expense_list_item.dart';

class DateHeaderWidget extends StatelessWidget {
  final ExpenseHeaderItem header;

  const DateHeaderWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _getDisplayDate(context, header.date),
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              context.l10n.dayTotal(currencyFormatter.format(121121)),
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return context.l10n.today;
    } else if (dateOnly == yesterday) {
      return context.l10n.yesterday;
    } else {
      return DateFormat('MMM dd EEEE').format(date);
    }
  }
}
