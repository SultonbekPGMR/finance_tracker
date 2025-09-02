// Created by Sultonbek Tulanov on 02-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/chart/domain/usecase/get_chart_data_usecase.dart';
import 'package:finance_tracker/feature/chart/presentation/widget/expense_pie_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/app_di.dart';
import '../../data/model/category_expense_data.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DateTime selectedMonth = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final List<CategoryExpenseData> chartData = [];

  // Generate last 12 months for selection
  List<DateTime> get availableMonths {
    final months = <DateTime>[];
    final now = DateTime.now();

    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      months.add(month);
    }

    return months;
  }

  @override
  void initState() {
    _getChartData(DateTime.now() );
    super.initState();
  }

  Future<void> _getChartData(DateTime month) async {
    final result = await get<GetChartDataUseCase>()(
      GetChartDataParams(month: month),
    );
    final chartData = result.getOrNull();
    if (chartData != null) {
      this.chartData.clear();
      setState(() {
        this.chartData.addAll(chartData);
      });
    }
  }

  void _selectMonth(DateTime month) {
    _getChartData(month);
    setState(() {
      selectedMonth = month;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 140,
              pinned: true,
              backgroundColor: context.colorScheme.surface,
              foregroundColor: context.colorScheme.onSurface,
              scrolledUnderElevation: 1,
              surfaceTintColor: context.colorScheme.surfaceTint,
              flexibleSpace: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title area
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          context.l10n.charts,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    // Month selector area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: context.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: availableMonths.length,
                          itemBuilder: (context, index) {
                            final month = availableMonths[index];
                            final isSelected =
                                month.month == selectedMonth.month &&
                                month.year == selectedMonth.year;

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _MonthChip(
                                month: month,
                                isSelected: isSelected,
                                onTap: () => _selectMonth(month),
                                colorScheme: context.colorScheme,
                                textTheme: context.textTheme,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ExpensePieChartWidget(
                    selectedMonth: selectedMonth,
                    categoryExpenseDataList: chartData,
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final DateTime month;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MonthChip({
    required this.month,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentMonth = month.month == now.month && month.year == now.year;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
            borderRadius: BorderRadius.circular(16),
            border:
                isCurrentMonth && !isSelected
                    ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    )
                    : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('MMM').format(month),
                style: textTheme.labelLarge?.copyWith(
                  color:
                      isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('yyyy').format(month),
                style: textTheme.labelSmall?.copyWith(
                  color:
                      isSelected
                          ? colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          )
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
