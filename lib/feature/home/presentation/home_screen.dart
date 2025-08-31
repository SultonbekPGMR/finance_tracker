// Created by Sultonbek Tulanov on 30-August 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        height: 86,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.receipt_long_outlined,
              selectedIcon: Icons.receipt_long,
              label: context.l10n.records,
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.pie_chart_outline,
              selectedIcon: Icons.pie_chart,
              label: context.l10n.charts,
              index: 1,
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () => context.pushNamed('add-expense'),
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child:  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.bar_chart_outlined,
              selectedIcon: Icons.bar_chart,
              label: context.l10n.reports,
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
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
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

 
