// Created by Sultonbek Tulanov on 02-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../expense/data/model/expense_category_model.dart';
import '../../data/model/category_expense_data.dart';

class ExpensePieChartWidget extends StatefulWidget {
  final List<CategoryExpenseData>? categoryExpenseDataList;
  final DateTime selectedMonth;

  const ExpensePieChartWidget({
    super.key,
    this.categoryExpenseDataList,
    required this.selectedMonth,
  });

  @override
  State<ExpensePieChartWidget> createState() => _ExpensePieChartWidgetState();
}

class _ExpensePieChartWidgetState extends State<ExpensePieChartWidget> {
  int touchedIndex = -1;
  bool _isUserInteracting = false;

  // Mock data for development - this demonstrates the system with realistic expense data
  List<CategoryExpenseData> get mockData => [
    CategoryExpenseData(
      category: ExpenseCategoryModel.food,
      totalAmount: 1250.50,
      transactionCount: 15,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.transport,
      totalAmount: 650.25,
      transactionCount: 8,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.entertainment,
      totalAmount: 420.75,
      transactionCount: 6,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.shopping,
      totalAmount: 890.00,
      transactionCount: 12,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.utilities,
      totalAmount: 340.30,
      transactionCount: 4,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.health,
      totalAmount: 275.80,
      transactionCount: 3,
    ),
    CategoryExpenseData(
      category: ExpenseCategoryModel.home,
      totalAmount: 156.90,
      transactionCount: 2,
    ),
  ];

  List<CategoryExpenseData> get categoryData {
    final categoryExpenseDataList = widget.categoryExpenseDataList;
    if (categoryExpenseDataList == null) return mockData;
    return categoryExpenseDataList;
  }

  double get totalAmount =>
      categoryData.fold(0, (sum, data) => sum + data.totalAmount);

  // Find the category with highest spending - this becomes our default highlight
  CategoryExpenseData get topSpendingCategory {
    if (categoryData.isEmpty) {
      return CategoryExpenseData(
        category: ExpenseCategoryModel.other,
        totalAmount: 0,
        transactionCount: 0,
      );
    }

    return categoryData.reduce(
      (current, next) =>
          current.totalAmount > next.totalAmount ? current : next,
    );
  }

  // Determine which category should be highlighted based on user interaction
  CategoryExpenseData get highlightedCategory {
    if (_isUserInteracting &&
        touchedIndex >= 0 &&
        touchedIndex < categoryData.length) {
      return categoryData[touchedIndex];
    }
    return topSpendingCategory;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(currencyFormatter),
        const SizedBox(height: 32),
        _buildChart(),
        const SizedBox(height: 24),
        _buildHighlightedCategory(currencyFormatter),
        const SizedBox(height: 24),
        _buildLegend(currencyFormatter),
      ],
    );
  }

  Widget _buildHeader(NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pie_chart_rounded,
              color: context.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.expensesByCategory,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.totalSpent(' '),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                currencyFormatter.format(totalAmount),
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (categoryData.isEmpty) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Text(
            context.l10n.noExpensesFound,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                // Track when user starts/stops interacting with the chart
                final wasInteracting = _isUserInteracting;
                _isUserInteracting = event.isInterestedForInteractions;

                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  // Add slight delay before clearing interaction state to prevent flickering
                  if (wasInteracting) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        setState(() {
                          _isUserInteracting = false;
                        });
                      }
                    });
                  }
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: _buildPieChartSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return categoryData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.totalAmount / totalAmount) * 100;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65.0 : 55.0;
      const fontSize = 14.0;

      return PieChartSectionData(
        color: data.category.color,
        value: data.totalAmount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        badgeWidget:
            isTouched
                ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.shadow.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    data.category.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
                : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  // This creates the prominent category highlight that shows either the top spending
  // category by default, or the currently selected category during interaction
  Widget _buildHighlightedCategory(NumberFormat currencyFormatter) {
    if (categoryData.isEmpty) return const SizedBox();
    final highlighted = highlightedCategory;
    final percentage = (highlighted.totalAmount / totalAmount) * 100;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey(highlighted.category.name), // Key for AnimatedSwitcher
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                highlighted.category.color.withValues(alpha: 0.15),
                highlighted.category.color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: highlighted.category.color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Large category icon with themed background
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: highlighted.category.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    highlighted.category.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Category details with comprehensive information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          highlighted.category.displayName,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: highlighted.category.color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormatter.format(highlighted.totalAmount),
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: highlighted.category.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.transactionCount(highlighted.transactionCount),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categoryData.isNotEmpty)
          Text(
            context.l10n.categoryBreakdown,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
        const SizedBox(height: 16),
        ...categoryData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final percentage = (data.totalAmount / totalAmount) * 100;
          final isSelected = index == touchedIndex;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? data.category.color.withValues(alpha: 0.1)
                      : context.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected
                        ? data.category.color.withValues(alpha: 0.3)
                        : context.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: data.category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: data.category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      data.category.icon,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.category.displayName,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        context.l10n.transactionCount(data.transactionCount),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(data.totalAmount),
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: data.category.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
