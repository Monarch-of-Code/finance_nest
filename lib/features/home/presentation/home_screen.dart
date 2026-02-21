import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/navigation_provider.dart';
import '../../../app/providers/theme_provider.dart'; // ← Add this import
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/navigaton/presentation/navigatoin_widget.dart';
import '../../../core/widgets/navigaton/domain/navigation_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationProvider);
    ref.watch(themeModeProvider); // ← Watch theme so UI rebuilds on toggle
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme colors matching your design system
    final bgColor = isDark ? AppColors.voidColor : AppColors.honeydew;
    final navColor = isDark ? AppColors.cyprus : Colors.white;
    final iconColor = isDark ? AppColors.lightGreen : AppColors.cyprus;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Main Content Area
            Positioned.fill(
              bottom: 80,
              child: SafeArea(
                bottom: false,
                child: _buildBody(currentTab, isDark),
              ),
            ),

            // ── Theme Toggle Button (Top Right) ──
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cyprus.withOpacity(0.6)
                          : Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: iconColor,
                      ),
                      onPressed: () {
                        ThemeModeNotifier.toggleTheme();
                        ref.invalidate(themeModeProvider);
                      },
                      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(NavigationTab tab, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 48,
            color: isDark ? AppColors.lightGreen : AppColors.caribbeanGreen,
          ),
          const SizedBox(height: 16),
          Text(
            '${tab.label} Screen',
            style: AppFonts.headlineMedium.copyWith(
              color: isDark ? AppColors.honeydew : AppColors.cyprus,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: AppFonts.bodyMedium.copyWith(
              color: isDark ? AppColors.lightGreen : AppColors.oceanBlue,
            ),
          ),
        ],
      ),
    );
  }
}