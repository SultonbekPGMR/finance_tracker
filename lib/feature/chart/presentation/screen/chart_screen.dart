// Created by Sultonbek Tulanov on 02-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/chart/presentation/widget/expense_pie_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../bloc/chart_cubit.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _monthScrollController = ScrollController();
  final Map<String, GlobalKey> _monthKeys = {};

  @override
  void initState() {
    super.initState();
    context.read<ChartCubit>().loadCurrentMonthData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _monthScrollController.dispose();
    super.dispose();
  }

  String _getMonthKey(DateTime month) {
    return '${month.year}-${month.month}';
  }

  GlobalKey _getKeyForMonth(DateTime month) {
    final monthKey = _getMonthKey(month);
    if (!_monthKeys.containsKey(monthKey)) {
      _monthKeys[monthKey] = GlobalKey();
    }
    return _monthKeys[monthKey]!;
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChartCubit, ChartState>(
      listenWhen: (prev, curr) => curr is ChartLoaded,
      listener: (context, state) {
        if (state is ChartLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final globalKey = _getKeyForMonth(state.selectedMonth);

            if (globalKey.currentContext != null) {
              Scrollable.ensureVisible(
                globalKey.currentContext!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: 0.5,
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                BlocBuilder<ChartCubit, ChartState>(
                  buildWhen:
                      (prev, curr) => curr is ChartLoaded || curr is ChartError,
                  builder: (context, state) {
                    DateTime selectedMonth = DateTime.now();
                    List<DateTime> availableMonths = const <DateTime>[];

                    if (state is ChartLoaded) {
                      selectedMonth = state.selectedMonth;
                      availableMonths = state.availableMonths;
                    } else if (state is ChartError) {
                      selectedMonth = state.selectedMonth;
                      availableMonths = state.availableMonths;
                    }

                    return SliverAppBar(
                      toolbarHeight: 120,
                      pinned: true,
                      backgroundColor: context.colorScheme.surface,
                      foregroundColor: context.colorScheme.onSurface,
                      scrolledUnderElevation: 1,
                      surfaceTintColor: context.colorScheme.surfaceTint,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: TextButton(
                            onPressed: () => _showYearPicker(selectedMonth),
                            child: Row(
                              children: [
                                Text(
                                  selectedMonth.year.toString(),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colorScheme.onSurface,
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
                        ),
                      ],
                      flexibleSpace: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: context.colorScheme.outline
                                          .withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: ListView.builder(
                                  controller: _monthScrollController,
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
                                      key: _getKeyForMonth(month),
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _MonthChip(
                                        month: month,
                                        isSelected: isSelected,
                                        onTap:
                                            () => context
                                                .read<ChartCubit>()
                                                .changeMonth(month),
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
                    );
                  },
                ),
              ];
            },
            body: BlocBuilder<ChartCubit, ChartState>(
              builder: (context, state) {
                if (state is ChartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChartError) {
                  return Center(
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
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed:
                              () => context.read<ChartCubit>().refreshData(),
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  );
                } else if (state is ChartLoaded) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            ExpensePieChartWidget(
                              selectedMonth: state.selectedMonth,
                              categoryExpenseDataList: state.chartData,
                            ),
                            const SizedBox(height: 16),
                          ]),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showYearPicker(DateTime currentYear) async {
    final selected = await showYearPicker(
      context: context,
      initialDate: currentYear,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selected != null && mounted) {
      final onlyYear = DateTime(selected);
      context.read<ChartCubit>().changeYear(onlyYear);
    }
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
          child: Center(
            child: Text(
              DateFormat('MMM').format(month),
              style: textTheme.labelLarge?.copyWith(
                color:
                    isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
