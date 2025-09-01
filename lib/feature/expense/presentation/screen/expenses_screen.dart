// Created by Sultonbek Tulanov on 01-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../data/model/expense_model.dart';
import '../bloc/expenses_bloc.dart';
import '../model/expense_list_item.dart';
import '../widget/date_header_widget.dart';
import '../widget/expense_item_widget.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(state),
              if (_isSearchVisible) _buildSearchSliver(),
              ...switch (state) {
                ExpensesInitial() => [
                  SliverToBoxAdapter(child: _buildInitialState()),
                ],
                ExpensesLoading() => [
                  SliverToBoxAdapter(child: _buildLoadingState()),
                ],
                ExpensesLoaded loaded => _buildExpensesSlivers(loaded),
                ExpensesError error => [
                  SliverToBoxAdapter(child: _buildErrorState(error.message)),
                ],
                ExpensesState() => [
                  const SliverToBoxAdapter(child: SizedBox()),
                ],
              },
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ExpensesState state) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final scrolled = constraints.scrollOffset / 120;
        final isCollapsed = scrolled >= 0.5;

        return SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          elevation: 0,
          leading:
              isCollapsed && state is ExpensesLoaded
                  ? _buildMonthPicker(state)
                  : null,
          leadingWidth: isCollapsed ? 80 : 0,
          title: Text(
            context.l10n.moneyTracker,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isSearchVisible ? Icons.close : Icons.search,
                color: context.colorScheme.onSurface,
              ),
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                  if (!_isSearchVisible) {
                    _searchController.clear();
                    context.read<ExpensesBloc>().add(SearchExpensesEvent(''));
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_month,
                color: context.colorScheme.onSurface,
              ),
              onPressed: () {
                if (state is ExpensesLoaded) {
                  _showMonthPicker(state.selectedDate);
                }
              },
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background:
                state is ExpensesLoaded
                    ? _buildFlexibleContent(state, scrolled, isCollapsed)
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildMonthPicker(ExpensesLoaded state) {
    return InkWell(
      onTap: () => _showMonthPicker(state.selectedDate),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('MMM').format(state.selectedDate),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: context.colorScheme.onSurface,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleContent(
    ExpensesLoaded state,
    double scrolled,
    bool isCollapsed,
  ) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 16, 16),
        child: Row(
          children: [
            // Month picker - hide when collapsed (moves to leading)
            if (!isCollapsed) _buildMonthPickerInline(state),
            const Spacer(),
            // Expense stats - fade out as we scroll
            Opacity(
              opacity: (1 - scrolled * 2).clamp(0.0, 1.0),
              child: _buildExpenseStats(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPickerInline(ExpensesLoaded state) {
    return InkWell(
      onTap: () => _showMonthPicker(state.selectedDate),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.selectedDate.year.toString(),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              DateFormat('MMMM').format(state.selectedDate),
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: context.colorScheme.onSurface,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseStats(ExpensesLoaded state) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.expenses,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          currencyFormatter.format(state.totalAmount),
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSliver() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: context.l10n.searchExpenses,
            prefixIcon: Icon(
              Icons.search,
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        context.read<ExpensesBloc>().add(
                          SearchExpensesEvent(''),
                        );
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            context.read<ExpensesBloc>().add(SearchExpensesEvent(value));
          },
        ),
      ),
    );
  }

  List<Widget> _buildExpensesSlivers(ExpensesLoaded state) {
    if (state.expenses.isEmpty) {
      return [
        SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState()),
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ];
    }
    return [
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = state.expenses[index];
          return switch (item) {
            ExpenseHeaderItem header => DateHeaderWidget(header: header),
            ExpenseDataItem data => ExpenseItemWidget(
              expense: data.expense,
              onTap: () {
                // Navigate to expense details
              },
              onLongPress: () {
                _showExpenseOptions(data.expense);
              },
            ),
          };
        }, childCount: state.expenses.length),
      ),
      if (state.expenses.length < 12)
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
    ];
  }

  Widget _buildInitialState() {
    return SizedBox(
      height: context.screenHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: context.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.loadingExpenses,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: context.screenHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              context.l10n.loadingExpenses,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SizedBox(
      height: context.screenHeight * 0.5,
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
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ExpensesBloc>().add(LoadExpensesEvent());
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: context.screenHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noExpensesFound,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.startAddingExpenses,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthPicker(DateTime currentMonth) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: currentMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selected != null && mounted) {
      context.read<ExpensesBloc>().add(ChangeMonthEvent(selected));
    }
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
}
