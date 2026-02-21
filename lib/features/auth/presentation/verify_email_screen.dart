import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/exit_confirmation_dialog.dart';
import '../../../core/utils/page_route_utils.dart';
// import '../../../core/widgets/widget_showcase_screen.dart';
import '../../home/presentation/home_screen.dart';
import 'new_password_screen.dart';

/// Verify Email screen for email verification with 6-digit code
class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isFromForgotPassword;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.isFromForgotPassword = false,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendCooldown = 0;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleCodeChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field if not the last one
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled, unfocus
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // If deleting, move to previous field
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleVerify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      // Bypass validation for "000000"
      if (code == '000000') {
        // Navigate based on flow type
        if (widget.isFromForgotPassword) {
          Navigator.pushReplacement(
            context,
            createSlideRoute(const NewPasswordScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            createSlideRoute(const HomeScreen()),
          );
        }
        return;
      }

      setState(() {
        _isVerifying = true;
      });

      // TODO: Implement email verification API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
          // Navigate based on flow type
          if (widget.isFromForgotPassword) {
            // Navigate to new password screen after successful verification
            Navigator.pushReplacement(
              context,
              createSlideRoute(const NewPasswordScreen()),
            );
          } else {
            // Navigate to widget showcase screen after successful verification
            Navigator.pushReplacement(
              context,
              createSlideRoute(const HomeScreen()),
            );
          }
        }
      });
    }
  }

  void _handleResend() {
    if (_resendCooldown > 0) return;

    // TODO: Implement resend OTP API call
    setState(() {
      _resendCooldown = 60;
    });

    // Start countdown timer
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCooldown--;
        });
        return _resendCooldown > 0;
      }
      return false;
    });
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

    // Border color for digit inputs (theme-aware)
    final borderColor = isDark
        ? AppColors.lightGreen
        : AppColors.caribbeanGreen;

    // Button background color (theme-aware)
    final buttonColor = AppColors.caribbeanGreen;

    // Set system UI overlay style - only change bottom nav bar, keep top bar as global settings
    return PopScope(
      canPop: false, // Prevent going back
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
                // Top section with "Verify Email" title
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
                        'Verify Email',
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
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 80,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // "Enter 6 digit code" text
                          Text(
                            'Enter 6 digit code',
                            textAlign: TextAlign.center,
                            style: AppFonts.titleMedium.copyWith(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 60),
                          // 6 circular input fields for PIN code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: AppFonts.titleLarge.copyWith(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: false,
                                    contentPadding:
                                        EdgeInsets.zero, // Center text properly
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _handleCodeChanged(index, value);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 80),
                          // Verify button
                          Center(
                            child: PrimaryButton(
                              text: 'Verify',
                              size: ButtonSize.md,
                              isFullWidth: false,
                              backgroundColor: buttonColor,
                              onPressed: _isVerifying ? null : _handleVerify,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Resend code text
                          Center(
                            child: GestureDetector(
                              onTap: _resendCooldown > 0 ? null : _handleResend,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Didn't receive code? ",
                                    ),
                                    TextSpan(
                                      text: _resendCooldown > 0
                                          ? 'Resend (${_resendCooldown}s)'
                                          : 'Resend',
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: _resendCooldown > 0
                                            ? textColor.withValues(alpha: 0.5)
                                            : buttonColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
