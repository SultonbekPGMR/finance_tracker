// Updated: lib/feature/chart/presentation/widget/expense_pie_chart_widget.dart
import 'dart:math' as math;

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../expense/data/model/expense_category_model.dart';
import '../../data/model/category_expense_data.dart';

enum ChartDisplayType { pie, bar }

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

class _ExpensePieChartWidgetState extends State<ExpensePieChartWidget>
    with TickerProviderStateMixin {
  static  ChartDisplayType _persistentChartType = ChartDisplayType.pie;
  int touchedIndex = -1;
  bool _isUserInteracting = false;
  ChartDisplayType _currentChartType = ChartDisplayType.pie;

  late AnimationController _progressController;
  late AnimationController _donutController;
  late AnimationController _chartSwitchController;
  late Animation<double> _chartSwitchAnimation;

  @override
  void initState() {
    super.initState();
    _currentChartType = _persistentChartType;
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _donutController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _chartSwitchController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _chartSwitchAnimation = CurvedAnimation(
      parent: _chartSwitchController,
      curve: Curves.easeInOutCubic,
    );

    _donutController.forward();
    _progressController.forward();
    _chartSwitchController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _donutController.dispose();
    _chartSwitchController.dispose();
    super.dispose();
  }

  List<CategoryExpenseData> get categoryData {
    final categoryExpenseDataList = widget.categoryExpenseDataList;
    if (categoryExpenseDataList == null) return [];
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

  void _onProgressRingTap(int index) {
    if(touchedIndex == index){
      context.push('/expenses-by-filter', extra: {
        'month': widget.selectedMonth,
        'category': categoryData[index].category,
      });
      return;
    }

    setState(() {
      touchedIndex = index;
      _isUserInteracting = true;
    });
  }

  void _switchChartType(ChartDisplayType newType) {
    if (_currentChartType == newType) return;

    _chartSwitchController.reset();
    setState(() {
      _currentChartType = newType;
      _persistentChartType = newType;
      touchedIndex = -1;
      _isUserInteracting = false;
    });
    _chartSwitchController.forward();
  }
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(currencyFormatter),
        const SizedBox(height: 24),
        if (categoryData.isNotEmpty) _buildChartTypeSelector(),
        const SizedBox(height: 32),
        if (categoryData.isEmpty)
          buildEmptyBox(context)
        else ...[
          _buildChartContainer(),
          const SizedBox(height: 28),
          _buildProgressRingsList(currencyFormatter),
        ],
      ],
    );
  }

  Widget _buildChartTypeSelector() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ChartDisplayType.values.asMap().entries.map((entry) {
            final index = entry.key;
            final type = entry.value;
            final isSelected = _currentChartType == type;
            final isLast = index == ChartDisplayType.values.length - 1;

            return GestureDetector(
              onTap: () => _switchChartType(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOutCubic,
                margin: EdgeInsets.only(right: isLast ? 0 : 4),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: context.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == ChartDisplayType.pie
                          ? Icons.donut_large_rounded
                          : Icons.bar_chart_rounded,
                      size: 18,
                      color: isSelected
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type == ChartDisplayType.pie ? context.l10n.pieChart : context.l10n.barChart,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? context.colorScheme.onPrimary
                            : context.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildChartContainer() {
    return AnimatedBuilder(
      animation: _chartSwitchAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * _chartSwitchAnimation.value),
          child: Opacity(
            opacity: _chartSwitchAnimation.value,
            child:
                _currentChartType == ChartDisplayType.pie
                    ? _buildDonutChart()
                    : _buildBarChart(),
          ),
        );
      },
    );
  }

  SizedBox buildEmptyBox(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 2.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.noExpensesFound,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primary.withValues(alpha: 0.05),
                context.colorScheme.primary.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: context.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.totalSpent(' '),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        currencyFormatter.format(totalAmount),
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      height: context.screenWidth / 1.5,
      child: AnimatedBuilder(
        animation: _donutController,
        builder: (context, child) {
          return Stack(
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        final wasInteracting = _isUserInteracting;
                        _isUserInteracting = event.isInterestedForInteractions;

                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          if (wasInteracting) {
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                if (mounted) {
                                  setState(() {
                                    _isUserInteracting = false;
                                  });
                                }
                              },
                            );
                          }
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 85,
                  sections: _buildDonutSections(),
                ),
              ),
              Positioned.fill(child: Center(child: _buildDonutCenter())),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBarChart() {
    final maxAmount = categoryData
        .map((e) => e.totalAmount)
        .fold(0.0, (a, b) => math.max(a, b));

    return Container(
      height: context.screenWidth / 1.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxAmount * 1.1,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => context.colorScheme.primary.withValues(alpha: 0.7),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final category = categoryData[group.x.toInt()];
                final currencyFormatter = NumberFormat.currency(symbol: '\$');
                return BarTooltipItem(
                  '${category.category.getLocalizedName(context)}\n${currencyFormatter.format(rod.toY)}',
                  TextStyle(
                    color: context.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (barTouchResponse?.spot?.touchedBarGroupIndex != null) {
                setState(() {
                  touchedIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
                  _isUserInteracting = true;
                });
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 70,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < categoryData.length) {
                    final category = categoryData[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category.category.icon,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Transform.rotate(
                            angle: -0.4,
                            child: Text(
                              category.category.getLocalizedName(context).split(' ').first,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 70,
                interval: maxAmount / 4, // Add this line
                getTitlesWidget: (value, meta) {
                  final currencyFormatter = NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 0,
                  );
                  return Text(
                    currencyFormatter.format(value),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxAmount / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.colorScheme.outline.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          barGroups:
              categoryData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final isTouched = index == touchedIndex;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.totalAmount * _chartSwitchAnimation.value,
                      color: data.category.color,
                      width: isTouched ? 28 : 24,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          data.category.color,
                          data.category.color.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildDonutCenter() {
    final highlighted = highlightedCategory;
    final percentage =
        totalAmount > 0 ? (highlighted.totalAmount / totalAmount) * 100 : 0;
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(
        key: ValueKey(highlighted.category.name),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: highlighted.category.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: highlighted.category.color.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    highlighted.category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                highlighted.category.getLocalizedName(context),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: highlighted.category.color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                currencyFormatter.format(highlighted.totalAmount),
                style: context.textTheme.bodySmall?.copyWith(
                  color: highlighted.category.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildDonutSections() {
    return categoryData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.totalAmount / totalAmount) * 100;
      final isTouched = index == touchedIndex;
      final baseRadius = 45.0;
      final touchRadius = 52.0;
      final animatedRadius =
          _donutController.value * (isTouched ? touchRadius : baseRadius);

      return PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            data.category.color,
            data.category.color.withValues(alpha: 0.7),
            data.category.color,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        value: data.totalAmount * _donutController.value,
        title:
            _donutController.value > 0.8
                ? '${percentage.toStringAsFixed(0)}%'
                : '',
        radius: animatedRadius,
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: const Offset(0.5, 0.5),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildProgressRingsList(NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.categoryBreakdown,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...categoryData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final percentage = (data.totalAmount / totalAmount) * 100;
          final isSelected = index == touchedIndex;

          return _buildProgressRingItem(
            data,
            percentage,
            index,
            isSelected,
            currencyFormatter,
          );
        }),
      ],
    );
  }

  Widget _buildProgressRingItem(
    CategoryExpenseData data,
    double percentage,
    int index,
    bool isSelected,
    NumberFormat currencyFormatter,
  ) {
    final iconSize = context.screenWidth / 7;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onProgressRingTap(index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? data.category.color.withValues(alpha: 0.04)
                      : context.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected
                        ? data.category.color.withValues(alpha: 0.3)
                        : context.colorScheme.outline.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: data.category.color.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Row(
              children: [
                // Progress ring
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      final animatedPercentage =
                          percentage * _progressController.value;

                      return Stack(
                        children: [
                          // Background circle
                          Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: data.category.color.withValues(alpha: 0.1),
                              border: Border.all(
                                color: data.category.color.withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                          // Progress indicator
                          CustomPaint(
                            size: Size(iconSize, iconSize),
                            painter: ProgressRingPainter(
                              progress: animatedPercentage / 100,
                              color: data.category.color,
                              strokeWidth: 6,
                              backgroundColor: data.category.color.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          // Center icon
                          Center(
                            child: Text(
                              data.category.icon,
                              style: TextStyle(fontSize: iconSize * 0.4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Category info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data.category.getLocalizedName(context),
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              final animatedPercentage =
                                  percentage * _progressController.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: data.category.color.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${animatedPercentage.toStringAsFixed(1)}%',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: data.category.color,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                currencyFormatter.format(data.totalAmount),
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.transactionCount(
                              data.transactionCount,
                            ),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for progress rings with enhanced visuals
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with gradient effect
    if (progress > 0) {
      final progressPaint =
          Paint()
            ..color = color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Add subtle glow effect at the end of progress
      if (progress > 0.05) {
        final glowPaint =
            Paint()
              ..color = color.withValues(alpha: 0.4)
              ..strokeWidth = strokeWidth + 2
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round;

        final endAngle = startAngle + sweepAngle;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          endAngle - 0.1,
          0.1,
          false,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
