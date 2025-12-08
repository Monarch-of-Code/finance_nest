import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/utils/page_route_utils.dart';
import 'verify_email_screen.dart';

/// Forgot Password screen for password reset
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _showSuccess = false;
      });

      // TODO: Implement reset password API call
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
          // Navigate to verify email screen after successful reset password request
          Navigator.pushReplacement(
            context,
            createSlideRoute(
              VerifyEmailScreen(
                email: _emailController.text,
                isFromForgotPassword: true,
              ),
            ),
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

    // Text colors
    final textColor = isDark ? AppColors.lightGreen : AppColors.cyprus;

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
                            'Reset OTP sent successfully',
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
                    // Top section with "Forgot Password" title
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
                            'Forgot Password',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                // Reset Password heading
                                Text(
                                  'Reset Password',
                                  textAlign: TextAlign.left,
                                  style: AppFonts.titleLarge.copyWith(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Small paragraph (25 words)
                                Text(
                                  'Enter your email address and we will send you a link to reset your password and regain access to your account.',
                                  textAlign: TextAlign.left,
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: textColor,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Email input
                                AppInput(
                                  type: InputType.email,
                                  labelText: 'Email',
                                  hintText: 'example@example.com',
                                  showLabel: true,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 60),
                                // Reset Password button
                                Center(
                                  child: PrimaryButton(
                                    text: 'Reset Password',
                                    size: ButtonSize.md,
                                    isFullWidth: false,
                                    backgroundColor: buttonColor,
                                    onPressed: _handleResetPassword,
                                  ),
                                ),
                                const SizedBox(height: 32),
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
