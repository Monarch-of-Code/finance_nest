import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/utils/page_route_utils.dart';
import '../../../core/widgets/exit_confirmation_dialog.dart';
import 'auth_welcome_screen.dart';

/// Onboarding page data model
class OnboardingPage {
  final String title;
  final String imageAsset;

  const OnboardingPage({required this.title, required this.imageAsset});
}

/// Onboarding screen with multiple pages
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Welcome To\nFinance Nest',
      imageAsset: 'assets/images/img-1.png',
    ),
    OnboardingPage(
      title: '¿Are You Ready To Take Control Of Your Finances?',
      imageAsset: 'assets/images/img-2.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to auth welcome screen when clicking Next on last page
      Navigator.pushReplacement(
        context,
        createSlideRoute(const AuthWelcomeScreen()),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
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

    // Set system UI overlay style - only change bottom nav bar, keep top bar as global settings
    // Top bar should match global settings: honeydew (light) / fenceGreen (dark)
    // final topBarColor = isDark ? AppColors.fenceGreen : AppColors.caribbeanGreen;

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
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: overlapColor,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: Scaffold(
          bottomNavigationBar: Container(color: overlapColor, height: 0),
          backgroundColor:
              bgColor, // Use overlap color so bottom shows correctly
          body: SafeArea(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(
                  _pages[index],
                  bgColor,
                  textColor,
                  overlapColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
    OnboardingPage page,
    Color bgColor,
    Color textColor,
    Color overlapColor,
  ) {
    return Stack(
      children: [
        // Top section with title (40% of screen)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: AppFonts.titleLarge.copyWith(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),
        // Bottom overlapping section - covers entire bottom area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top:
              MediaQuery.of(context).size.height *
              0.35, // Start from 35% to overlap more
          child: Container(
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: overlapColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Illustration with circular background
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Circular background (behind image)
                    Container(
                      width: 280,
                      height: 280,
                      decoration: const BoxDecoration(
                        color: AppColors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Image on top of circle - positioned above everything
                    Positioned(
                      top: 0,
                      child: Image.asset(
                        page.imageAsset,
                        width:
                            260, // Slightly smaller than circle to touch border
                        height: 260,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          print('❌ Image error for ${page.imageAsset}: $error');
                          return Container(
                            width: 260,
                            height: 260,
                            color: Colors.red.withValues(alpha: 0.3),
                            child: const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                // Next button (just text, no background)
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    height: 50,
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
                      style: AppFonts.bodyLarge.copyWith(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? AppColors.caribbeanGreen
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.caribbeanGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
