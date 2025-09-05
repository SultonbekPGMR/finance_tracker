// Created by Sultonbek Tulanov on 03-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/model/expense_category_model.dart';
import '../bloc/expenses_bloc.dart';
import '../bloc/filtered_expenses/filtered_expenses_cubit.dart';

class ExpensesByFilterScreen extends StatefulWidget {
  final DateTime selectedMonth;
  final ExpenseCategoryModel selectedCategory;

  const ExpensesByFilterScreen({
    super.key,
    required this.selectedMonth,
    required this.selectedCategory,
  });

  @override
  State<ExpensesByFilterScreen> createState() => _ExpensesByFilterScreenState();
}
class _ExpensesByFilterScreenState extends State<ExpensesByFilterScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _expandAppBar() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showExpenseOptions(ExpenseModel expense) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(
                context.l10n.edit,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              onTap: () {
                context.pop();
                context.pushNamed('update-expense', extra: expense);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: context.colorScheme.error),
              title: Text(
                context.l10n.delete,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
              onTap: () {
                context.pop();
                _showDeleteConfirmation(expense);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showDeleteConfirmation(ExpenseModel expense) {
    final parentContext = context;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(
          context.l10n.deleteExpense,
          style: parentContext.textTheme.titleLarge?.copyWith(
            color: parentContext.colorScheme.onSurface,
          ),
        ),
        content: Text(
          parentContext.l10n.deleteConfirmation,
          style: parentContext.textTheme.bodyMedium?.copyWith(
            color: parentContext.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              parentContext.l10n.cancel,
              style: parentContext.textTheme.labelLarge?.copyWith(
                color: parentContext.colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              parentContext.read<ExpensesBloc>().add(
                DeleteExpenseEvent(expense.id),
              );
            },
            child: Text(
              parentContext.l10n.delete,
              style: parentContext.textTheme.labelLarge?.copyWith(
                color: parentContext.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: BlocBuilder<FilteredExpensesCubit, FilteredExpensesState>(
              builder: (context, state) {
                if (state is FilteredExpensesInitial) {
                  context.read<FilteredExpensesCubit>().loadExpenses(
                    widget.selectedMonth,
                    widget.selectedCategory,
                  );
                  return _buildLoadingContent(context);
                }

                if (state is FilteredExpensesLoading) {
                  return _buildLoadingContent(context);
                }

                if (state is FilteredExpensesError) {
                  return _buildErrorContent(context);
                }

                if (state is FilteredExpensesLoaded) {
                  if (state.expenses.isEmpty) {
                    return _buildEmptyContent(context);
                  }
                  return _buildExpensesContent(context, state.expenses);
                }

                return _buildLoadingContent(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scrolled = constraints.scrollOffset / 150;
        final isCollapsed = scrolled >= 0.9;
        final backgroundColor = isCollapsed ? context.colorScheme.surface : widget.selectedCategory.color.withValues(alpha: 0.1);

        return SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: backgroundColor,
          foregroundColor: widget.selectedCategory.color,
          surfaceTintColor: widget.selectedCategory.color,  // This adds the color effect

          title: isCollapsed
              ? GestureDetector(
            onTap: _expandAppBar,
                child: Text(
                            widget.selectedCategory.getLocalizedName(context),
                            style: context.textTheme.titleLarge?.copyWith(
                color: widget.selectedCategory.color,

                            )
                          ),
              )
              : null,
          actions: [
            if (isCollapsed)
              GestureDetector(
                onTap: _expandAppBar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    DateFormat('MMM yyyy').format(widget.selectedMonth),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.selectedCategory.color.withValues(alpha: 0.1),
                    widget.selectedCategory.color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: (1 - scrolled).clamp(0.0, 1.0),
                        duration: const Duration(milliseconds: 100),
                        child: Text(
                          widget.selectedCategory.getLocalizedName(context),
                          style: context.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<FilteredExpensesCubit, FilteredExpensesState>(
                          builder: (context, state) {
                            return _buildFlexibleSpaceContent(context, state);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildFlexibleSpaceContent(
    BuildContext context,
    FilteredExpensesState state,
  ) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.selectedCategory.color.withValues(alpha: 0.2),
                widget.selectedCategory.color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.selectedCategory.color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              widget.selectedCategory.icon,
              style: const TextStyle(fontSize: 36),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is FilteredExpensesLoading) ...[
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.colorScheme.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ] else if (state is FilteredExpensesLoaded) ...[
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    currencyFormatter.format(
                      state.expenses.fold<double>(
                        0,
                        (sum, expense) => sum + expense.amount,
                      ),
                    ),
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.selectedCategory.color,
                    ),
                  ),
                ),

                Text(
                  context.l10n.transactionCount(state.expenses.length),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat.yMMMM().format(widget.selectedMonth),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  context.l10n.noExpensesFound,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Container(
      height: context.screenHeight, // Full height to enable scrolling
      padding: const EdgeInsets.all(16),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Container(
      height: context.screenHeight, // Full height to enable scrolling
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.errorLoadingExpenses,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Container(
      height: context.screenHeight - context.appBarHeight,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.noExpensesFound,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.selectedCategory.getLocalizedName(context)} • ${DateFormat.yMMMM().format(widget.selectedMonth)}',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  Widget _buildExpensesContent(
    BuildContext context,
    List<ExpenseModel> expenses,
  ) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Container(
      constraints: BoxConstraints(
        minHeight: context.screenHeight - context.appBarHeight,
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // Disable inner scrolling
        itemCount: expenses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return InkWell(
              onTap: () {
                _showExpenseOptions(expense);
              },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.selectedCategory.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.description,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat.MMMd().format(expense.createdAt),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormatter.format(expense.amount),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.selectedCategory.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
