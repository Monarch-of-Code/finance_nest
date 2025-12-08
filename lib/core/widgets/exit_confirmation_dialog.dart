import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'app_button.dart';

/// Exit confirmation dialog widget
class ExitConfirmationDialog extends ConsumerWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Background colors
    final bgColor = isDark ? AppColors.cyprus : AppColors.honeydew;

    // Text colors
    final textColor = isDark ? AppColors.lightGreen : AppColors.cyprus;

    // Button colors (theme-aware)
    final buttonColor = isDark
        ? AppColors.lightGreen
        : AppColors.caribbeanGreen;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Exit App?',
              style: AppFonts.titleLarge.copyWith(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              'Are you sure you want to exit the app?',
              style: AppFonts.bodyMedium.copyWith(
                color: textColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Buttons row (No and Yes at bottom right)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // No button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: AppFonts.bodyMedium.copyWith(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Yes button
                PrimaryButton(
                  text: 'Yes',
                  size: ButtonSize.sm,
                  backgroundColor: buttonColor,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show exit confirmation dialog
Future<bool?> showExitConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ExitConfirmationDialog(),
  );
}

