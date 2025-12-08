import 'package:flutter/material.dart';
import '../../../core/utils/page_route_utils.dart';
import 'launch_screen.dart';
import 'onboarding_screen.dart';

/// Handles the splash/launch screen flow
class SplashHandler extends StatefulWidget {
  const SplashHandler({super.key});

  @override
  State<SplashHandler> createState() => _SplashHandlerState();
}

class _SplashHandlerState extends State<SplashHandler> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          createSlideRoute(const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LaunchScreen();
  }
}
