// Created by Sultonbek Tulanov on 30-August 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () => context.pushNamed('add-expense'),
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          elevation: 2,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        notchMargin: 6,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: context.l10n.main,
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.receipt_long_outlined,
              selectedIcon: Icons.receipt_long,
              label: context.l10n.records,
              index: 1,
            ),
            Expanded(flex: 3, child: const SizedBox()), // Space for the FAB
            
            _buildNavItem(
              context: context,
              icon: Icons.pie_chart_outline,
              selectedIcon: Icons.pie_chart,
              label: context.l10n.charts,
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: context.l10n.profile,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      flex: 4,
      child: InkWell(
        onTap: () => navigationShell.goBranch(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color:
                    isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color:
                      isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
