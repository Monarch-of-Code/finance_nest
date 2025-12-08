import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/exit_confirmation_dialog.dart';
import '../../../core/utils/page_route_utils.dart';
import 'signup_screen.dart';
import 'verify_email_screen.dart';
import 'forgot_password_screen.dart';

/// Login screen for user authentication
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _showSuccess = false;
      });

      // TODO: Implement login API call
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
          // Navigate to verify email screen after successful login
          Navigator.pushReplacement(
            context,
            createSlideRoute(VerifyEmailScreen(email: _emailController.text)),
          );
        }
      }
    }
  }

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
      _showSuccess = false;
    });

    // TODO: Implement Google login API call
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
        // Navigate to verify email screen after successful Google login
        Navigator.pushReplacement(
          context,
          createSlideRoute(
            const VerifyEmailScreen(
              email: '', // Google login might not need email verification
            ),
          ),
        );
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
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !Navigator.of(context).canPop()) {
          // Only show exit dialog if this is a root screen (can't go back)
          final shouldExit = await showExitConfirmationDialog(context);
          if (shouldExit == true) {
            // Exit the app
            SystemNavigator.pop();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                            'Login successful',
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
                    // Top section with "Log In" title
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
                            'Welcome',
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
                            vertical: 40,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
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
                                const SizedBox(height: 16),
                                // Password input
                                AppInput(
                                  type: InputType.password,
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  showLabel: true,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 100),
                                // Login button
                                Center(
                                  child: PrimaryButton(
                                    text: 'Log In',
                                    size: ButtonSize.md,
                                    isFullWidth: false,
                                    backgroundColor: buttonColor,
                                    onPressed: _handleLogin,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Forgot Password text
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        createSlideRoute(
                                          const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: buttonColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Sign up with text
                                Text(
                                  'or sign up with',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Google sign in button
                                Center(
                                  child: GestureDetector(
                                    onTap: _handleGoogleLogin,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: overlapColor,
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final imagePath = isDark
                                              ? 'assets/images/auth/g-dark.png'
                                              : 'assets/images/auth/g-light.png';
                                          return Image.asset(
                                            imagePath,
                                            key: ValueKey(
                                              'google_${isDark ? 'dark' : 'light'}',
                                            ),
                                            width: 44,
                                            height: 44,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  print(
                                                    '❌ Google icon error: $error',
                                                  );
                                                  print('isDark: $isDark');
                                                  print(
                                                    'Trying to load: $imagePath',
                                                  );
                                                  return Icon(
                                                    Icons.login,
                                                    size: 24,
                                                    color: textColor,
                                                  );
                                                },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Don't have an account? Sign Up
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          createSlideRoute(
                                            const SignupScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: buttonColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),
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
      ),
    );
  }
}
