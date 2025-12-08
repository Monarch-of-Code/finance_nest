import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/providers/theme_provider.dart';
import 'core/constants/app_colors.dart';
import 'core/utils/page_route_utils.dart';
import 'features/auth/presentation/splash_handler.dart';
import 'features/auth/presentation/signup_screen.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set initial system UI overlay style (light mode default)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.honeydew,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.honeydew,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const ProviderScope(child: FinanceNestApp()));
}

class FinanceNestApp extends ConsumerStatefulWidget {
  const FinanceNestApp({super.key});

  @override
  ConsumerState<FinanceNestApp> createState() => _FinanceNestAppState();
}

class _FinanceNestAppState extends ConsumerState<FinanceNestApp> {
  ThemeMode? _lastThemeMode;

  @override
  void initState() {
    super.initState();
    _lastThemeMode = ref.read(themeModeProvider).mode;
    // Update system UI immediately on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSystemUI();
    });
  }

  void _updateSystemUI() {
    final theme = ref.read(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // Status bar (top) - shows time, battery, signal
        // Light mode: light background (honeydew) with dark icons
        // Dark mode: dark background (fenceGreen) with light icons
        statusBarColor: isDark ? AppColors.fenceGreen : AppColors.honeydew,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,

        // Navigation bar (bottom) - shows navigation buttons
        systemNavigationBarColor: isDark
            ? AppColors.voidColor
            : AppColors.honeydew,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final themeModeState = ref.watch(themeModeProvider);

    // Only update system UI if theme mode actually changed
    if (_lastThemeMode != themeModeState.mode) {
      _lastThemeMode = themeModeState.mode;
      // Update system UI synchronously when theme changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateSystemUI();
      });
    }

    return MaterialApp(
      title: 'Finance Nest',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: themeModeState.mode,
      home: const SplashHandler(),
      // Use custom page route builder for all named routes with slide transition
      onGenerateRoute: (settings) {
        // For named routes, use slide transition
        switch (settings.name) {
          case '/signup':
            return createSlideRoute(const SignupScreen());
          case '/login':
            return createSlideRoute(const LoginScreen());
          default:
            return null;
        }
      },
    );
  }
}
