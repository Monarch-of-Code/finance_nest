import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/utils/page_route_utils.dart';
import 'login_screen.dart';

/// New Password screen for setting a new password after password reset
class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _showSuccess = false;
      });

      // TODO: Implement change password API call
      // Simulate API call with 5 second delay
      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });

        // Wait 2 seconds to show success message
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          // Navigate to login screen after successful password change
          // Clear entire navigation stack to prevent going back to password reset flow
          Navigator.pushAndRemoveUntil(
            context,
            createSlideRoute(const LoginScreen()),
            (route) => false, // Remove all previous routes
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Background colors
    final bgColor = isDark ? AppColors.fenceGreen : AppColors.caribbeanGreen;

    // Overlapping section color
    final overlapColor = isDark ? AppColors.cyprus : AppColors.honeydew;

    // Button and link color (theme-aware)
    final buttonColor =  AppColors.caribbeanGreen;

    // Set system UI overlay style - only change bottom nav bar, keep top bar as global settings
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: overlapColor,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        bottomNavigationBar: Container(color: overlapColor, height: 0),
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              // Loading/Success overlay
              if (_isLoading || _showSuccess)
                Container(
                  color: bgColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppLoader(
                          state: _isLoading
                              ? LoaderState.loading
                              : (_showSuccess
                                    ? LoaderState.success
                                    : LoaderState.loading),
                          size: 80,
                          backgroundColor:
                              AppColors.lightGreen, // Always Light Green
                          successColor:
                              AppColors.lightGreen, // Always Light Green
                        ),
                        if (_showSuccess) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Password changed successfully',
                            style: AppFonts.titleMedium.copyWith(
                              color: isDark
                                  ? AppColors.lightGreen
                                  : AppColors.cyprus,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              // Main content (hidden when loading)
              if (!_isLoading && !_showSuccess)
                Stack(
                  children: [
                    // Top section with "New Password" title
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Container(
                        color: bgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: Text(
                            'New Password',
                            textAlign: TextAlign.center,
                            style: AppFonts.titleLarge.copyWith(
                              color: isDark
                                  ? AppColors.lightGreen
                                  : AppColors.cyprus,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Bottom overlapping section with form
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.2,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: overlapColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 22,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 30),
                                // New Password input
                                AppInput(
                                  type: InputType.password,
                                  labelText: 'New Password',
                                  hintText: 'Enter your new password',
                                  showLabel: true,
                                  controller: _newPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your new password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Confirm New Password input
                                AppInput(
                                  type: InputType.password,
                                  labelText: 'Confirm New Password',
                                  hintText: 'Confirm your new password',
                                  showLabel: true,
                                  controller: _confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your new password';
                                    }
                                    if (value != _newPasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 100),
                                // Change Password button
                                Center(
                                  child: PrimaryButton(
                                    text: 'Change Password',
                                    size: ButtonSize.md,
                                    isFullWidth: false,
                                    backgroundColor: buttonColor,
                                    onPressed: _handleChangePassword,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

