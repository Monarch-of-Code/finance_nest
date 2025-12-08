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

/// Signup screen for creating a new account
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _showSuccess = false;
      });

      // TODO: Implement signup API call
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
          // Navigate to verify email screen
          Navigator.pushReplacement(
            context,
            createSlideRoute(
              VerifyEmailScreen(email: _emailController.text),
            ),
          );
        }
      }
    }
  }

  void _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
      _showSuccess = false;
    });

    // TODO: Implement Google signup API call
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
        // Navigate to verify email screen
        Navigator.pushReplacement(
          context,
          createSlideRoute(
            const VerifyEmailScreen(
              email: '', // Google signup might not need email verification
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
                            'Account registered successfully',
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
                    // Top section with "Create Account" title
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
                            'Create Account',
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
                        // padding: EdgeInsets.only(top: 3),
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
                                const SizedBox(height: 16),
                                // Full Name input
                                AppInput(
                                  type: InputType.text,
                                  labelText: 'Full Name',
                                  hintText: 'Enter your full name',
                                  showLabel: true,
                                  // textColor not specified - will default to AppColors.cyprus
                                  controller: _fullNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Email input
                                AppInput(
                                  type: InputType.email,
                                  labelText: 'Email',
                                  hintText: 'example@example.com',
                                  showLabel: true,
                                  // textColor not specified - will default to AppColors.cyprus
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
                                // Mobile Number input
                                AppInput(
                                  type: InputType.phone,
                                  labelText: 'Mobile Number',
                                  hintText: '+ 123 456 789',
                                  showLabel: true,
                                  // textColor not specified - will default to AppColors.cyprus
                                  controller: _mobileController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your mobile number';
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
                                  // textColor not specified - will default to AppColors.cyprus
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Confirm Password input
                                AppInput(
                                  type: InputType.password,
                                  labelText: 'Confirm Password',
                                  hintText: 'Confirm your password',
                                  showLabel: true,
                                  // textColor not specified - will default to AppColors.cyprus
                                  controller: _confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                // Terms and Privacy Policy text
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: AppFonts.bodySmall.copyWith(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'By continuing, you agree to ',
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // TODO: Navigate to Terms of Use
                                            print('Terms of Use tapped');
                                          },
                                          child: Text(
                                            'Terms of Use',
                                            style: AppFonts.bodySmall.copyWith(
                                              color: textColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // TODO: Navigate to Privacy Policy
                                            print('Privacy Policy tapped');
                                          },
                                          child: Text(
                                            'Privacy Policy',
                                            style: AppFonts.bodySmall.copyWith(
                                              color: textColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Sign Up button
                                Center(
                                  child: PrimaryButton(
                                    text: 'Sign Up',
                                    size: ButtonSize.md,
                                    isFullWidth: false,
                                    onPressed: _handleSignUp,
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
                                // Google sign up button
                                Center(
                                  child: GestureDetector(
                                    onTap: _handleGoogleSignUp,
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
                                // Already have an account? Log In
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        );
                                      },
                                      child: Text(
                                        'Log In',
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.caribbeanGreen,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
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
