import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';

/// Launch/Splash screen for the app
class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for launch screen (dark background, light icons)
    final systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: AppColors.caribbeanGreen,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.caribbeanGreen,
      systemNavigationBarIconBrightness: Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.caribbeanGreen,
        body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.caribbeanGreen,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon - SVG logo
                SvgPicture.asset(
                  'assets/images/launch-logo.svg',
                  width: 109,
                  height: 114.778,
                  colorFilter: const ColorFilter.mode(
                    AppColors.cyprus,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 10),
                // App Name
                Text(
                  'Finance Nest',
                  style: AppFonts.appTitle.copyWith(color: AppColors.lightGreen, fontSize: 44),
                  textAlign: TextAlign.center,             ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
