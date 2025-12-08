import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';

/// Theme mode provider - manages light/dark theme
/// Using a simple class to hold the theme mode state
class ThemeModeState {
  final ThemeMode mode;

  const ThemeModeState(this.mode);

  ThemeModeState copyWith(ThemeMode? mode) {
    return ThemeModeState(mode ?? this.mode);
  }
}

/// Global state holder for theme mode (simple approach)
class ThemeModeNotifier {
  static ThemeModeState _current = const ThemeModeState(ThemeMode.light);
  static final List<void Function(ThemeModeState)> _listeners = [];

  static ThemeModeState get current => _current;

  static void setThemeMode(ThemeMode mode) {
    _current = ThemeModeState(mode);
    for (var listener in _listeners) {
      listener(_current);
    }
  }

  static void toggleTheme() {
    setThemeMode(
      _current.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  static void addListener(void Function(ThemeModeState) listener) {
    _listeners.add(listener);
  }

  static void removeListener(void Function(ThemeModeState) listener) {
    _listeners.remove(listener);
  }
}

/// Theme mode provider - provides the current theme mode
final themeModeProvider = Provider<ThemeModeState>((ref) {
  return ThemeModeNotifier.current;
});

/// Theme provider - provides the current theme based on theme mode
final themeProvider = Provider<ThemeData>((ref) {
  final themeModeState = ref.watch(themeModeProvider);
  final themeMode = themeModeState.mode;

  switch (themeMode) {
    case ThemeMode.light:
      return AppTheme.lightTheme;
    case ThemeMode.dark:
      return AppTheme.darkTheme;
    case ThemeMode.system:
      // For now, default to light. Can be enhanced to detect system theme
      return AppTheme.lightTheme;
  }
});

/// Helper function to toggle theme
void toggleTheme(WidgetRef ref) {
  ThemeModeNotifier.toggleTheme();
  // Force provider to update by invalidating
  ref.invalidate(themeModeProvider);
}

/// Helper extension to easily access theme colors
extension ThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
