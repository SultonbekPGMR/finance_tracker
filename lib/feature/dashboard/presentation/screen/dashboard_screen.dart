// Created by Sultonbek Tulanov on 04-September 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/model/dashboard_data.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(
                  context,
                  state is DashboardLoaded ? state.data.userInfo : null,
                ),
                if (state is DashboardLoading)
                  SliverFillRemaining(child: _buildLoadingState(context))
                else if (state is DashboardError)
                  SliverFillRemaining(
                    child: _buildErrorState(context, state.message),
                  )
                else if (state is DashboardLoaded)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildMonthlyOverview(
                          context,
                          state.data.monthlyOverview,
                        ),
                        const SizedBox(height: 24),
                        _buildQuickStats(context, state.data.quickStats),
                        if (state.data.recentExpenses.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildRecentExpenses(
                            context,
                            state.data.recentExpenses,
                          ),
                          const SizedBox(height: 24),
                          _buildTopCategories(
                            context,
                            state.data.topCategories,
                          ),
                        ] else ...[
                          const SizedBox(height: 48),
                          _buildEmptyExpensesMessage(context),
                        ],
                      ]),
                    ),
                  )
                else
                  SliverFillRemaining(child: _buildInitialState(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserInfo? userInfo) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;

    if (hour < 12) {
      greeting = context.l10n.goodMorning;
    } else if (hour < 17) {
      greeting = context.l10n.goodAfternoon;
    } else {
      greeting = context.l10n.goodEvening;
    }

    return SliverAppBar(
      expandedHeight: 84,
      floating: false,
      pinned: false,
      backgroundColor: context.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$greeting 👋',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    if (userInfo != null)
                      Text(
                        userInfo.displayName,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
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

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            context.l10n.loadingDashboard,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.failedToLoadDashboard,
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
            onPressed: () => context.read<DashboardCubit>().refreshDashboard(),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 64,
            color: context.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.initializingDashboard,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview(BuildContext context, MonthlyOverview overview) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary.withValues(alpha: 1),
            context.colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(overview.month),
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormatter.format(overview.totalSpent),
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.spentThisMonth,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.daysRemaining(overview.daysRemaining),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, QuickStats stats) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.quickStats,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context: context,
                title: context.l10n.todayLabel,
                value: currencyFormatter.format(stats.todayAmount),
                subtitle: context.l10n.transactions(stats.todayTransactions),
                icon: Icons.today,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context: context,
                title: context.l10n.thisWeek,
                value: currencyFormatter.format(stats.weekAmount),
                subtitle: context.l10n.transactions(stats.weekTransactions),
                icon: Icons.calendar_view_week,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context: context,
                title: context.l10n.dailyAvg,
                value: currencyFormatter.format(stats.dailyAverage),
                subtitle: context.l10n.thisMonthLabel,
                icon: Icons.trending_up,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses(
    BuildContext context,
    List<RecentExpense> expenses,
  ) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.recentExpenses,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed('expenses', extra: DateTime.now());
              },
              child: Text(
                context.l10n.seeAll,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            children:
                expenses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final expense = entry.value;
                  final isLast = index == expenses.length - 1;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          isLast
                              ? null
                              : Border(
                                bottom: BorderSide(
                                  color: context.colorScheme.outline.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 1,
                                ),
                              ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              expense.categoryIcon,
                              style: const TextStyle(fontSize: 20),
                            ),
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
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                getLocalizedTimeAgo(expense.createdAt, context),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormatter.format(expense.amount),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategories(
    BuildContext context,
    List<TopCategory> categories,
  ) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.topCategories,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
            Text(
              context.l10n.thisMonth,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.pushNamed(
                    'expenses-by-filter',
                    extra: {
                      'month': DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                      'category': category.categoryModel,
                    },
                  );
                },
                child: Ink(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.colorScheme.outline.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(60, 60),
                              painter: CategoryProgressPainter(
                                progress: category.percentage / 100,
                                color: context.colorScheme.primary,
                                strokeWidth: 4,
                              ),
                            ),
                            // Center icon
                            Center(
                              child: Text(
                                category.categoryModel.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    category.categoryModel.getLocalizedName(
                                      context,
                                    ),
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${category.percentage}%',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.primary,
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
                                  currencyFormatter.format(category.amount),
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: context.colorScheme.onSurface
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  context.l10n.transactions(
                                    category.transactionCount,
                                  ),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
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
        }),
      ],
    );
  }

  Widget _buildEmptyExpensesMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 100, top: 32),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text('💸', style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            context.l10n.recentExpensesEmptyTitle,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.recentExpensesEmptyMessage,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  String getLocalizedTimeAgo(DateTime dateTime, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return context.l10n.minutesAgo(difference.inMinutes);
      }
      return context.l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return context.l10n.yesterday;
    } else {
      return context.l10n.daysAgo(difference.inDays);
    }
  }
}

// Custom painter for category progress rings
class CategoryProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CategoryProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Progress arc
    if (progress > 0) {
      final progressPaint =
          Paint()
            ..color = color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      const startAngle = -1.5708; // -π/2 (top of circle)
      final sweepAngle = 6.2832 * progress.clamp(0.0, 1.0); // 2π * progress

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CategoryProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
