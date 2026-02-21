import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/navigation_provider.dart';
import '../../../constants/app_colors.dart';
import '../domain/navigation_service.dart';

class AppBottomNavigation extends ConsumerWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colors derived from your AppTheme logic
    final backgroundColor = isDark ? AppColors.cyprus : Colors.white;
    final selectedItemColor = AppColors.caribbeanGreen;
    final unselectedItemColor = isDark ? AppColors.lightGreen : AppColors.cyprus;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), // Extra bottom padding for SafeArea
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: NavigationTab.values.map((tab) {
          final isSelected = currentTab == tab;
          return _NavItem(
            icon: _getIconForTab(tab),
            label: tab.label,
            isSelected: isSelected,
            selectedColor: selectedItemColor,
            unselectedColor: unselectedItemColor,
            onTap: () => ref.read(navigationProvider.notifier).setTab(tab),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home:
        return Icons.grid_view_rounded; // Dashboard icon
      case NavigationTab.analysis:
        return Icons.pie_chart_rounded;
      case NavigationTab.transactions:
        return Icons.swap_horiz_rounded;
      case NavigationTab.budgets:
        return Icons.account_balance_wallet_rounded;
      case NavigationTab.profile:
        return Icons.person_rounded;
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            // Optional: Hide text if not selected for cleaner look, or keep it small
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selectedColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}