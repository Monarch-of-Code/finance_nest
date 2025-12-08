import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/exit_confirmation_dialog.dart';
import '../../../app/providers/theme_provider.dart' as theme_provider;
import '../../../core/utils/page_route_utils.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

/// Welcome/Auth screen with login and signup options
class AuthWelcomeScreen extends ConsumerWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Background color based on theme
    final backgroundColor = isDark ? AppColors.fenceGreen : AppColors.honeydew;

    // Text colors for description and forgot password
    final descriptionColor = isDark
        ? AppColors.lightGreen
        : AppColors.voidColor;

    // Set system UI overlay style to match the screen background
    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await showExitConfirmationDialog(context);
          if (shouldExit == true) {
            // Exit the app
            SystemNavigator.pop();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemOverlayStyle,
        child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          actionsPadding: const EdgeInsets.only(right: 30, top: 10),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: systemOverlayStyle,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppColors.caribbeanGreen,
              ),
              onPressed: () {
                theme_provider.toggleTheme(ref);
              },
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Logo
                SvgPicture.asset(
                  'assets/images/launch-logo2.svg',
                  width: 118,
                  height: 124,
                  colorFilter: const ColorFilter.mode(
                    AppColors.caribbeanGreen,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 10),
                // App Name
                Text(
                  'Finance Nest',
                  style: AppFonts.appTitle.copyWith(
                    color: AppColors.caribbeanGreen,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // Description/Tagline
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Your smart finance companion — track expenses, manage budgets, and reach your goals with confidence.',
                    textAlign: TextAlign.center,
                    style: AppFonts.bodyMedium.copyWith(
                      color: descriptionColor,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Log In Button
                      PrimaryButton(
                        text: 'Log In',
                        size: ButtonSize.md,
                        isFullWidth: true,
                        onPressed: () {
                          // Navigate directly to login screen
                          Navigator.push(
                            context,
                            createSlideRoute(const LoginScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Sign Up Button
                      SecondaryButton(
                        text: 'Sign Up',
                        size: ButtonSize.md,
                        isFullWidth: true,
                        onPressed: () {
                          // Navigate directly to signup screen
                          Navigator.push(
                            context,
                            createSlideRoute(
                              const SignupScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
