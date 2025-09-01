// Created by Sultonbek Tulanov on 01-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_category_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/model/expense_model.dart';

class ExpenseItemWidget extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ExpenseItemWidget({
    Key? key,
    required this.expense,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      ExpenseCategoryModel.fromString(expense.category).icon,
                      style: context.textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Expense Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        expense.description.isEmpty
                            ? context.l10n.noDescription
                            : expense.description,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              expense.description.isEmpty
                                  ? context.colorScheme.onSurface.withOpacity(
                                    0.6,
                                  )
                                  : context.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Category
                      Text(
                        expense.category,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount and Image Indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Amount
                    Text(
                      currencyFormatter.format(expense.amount),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.primary,
                      ),
                    ),

                    // Image indicator
                    if (expense.imageUrl != null &&
                        expense.imageUrl!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          size: 12,
                          color: context.colorScheme.onTertiaryContainer,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
