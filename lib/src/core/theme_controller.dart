import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla el ThemeMode (light/dark) y persiste la elección.
class ThemeModeController extends ChangeNotifier {
  static const _key = 'themeMode';
  ThemeMode _mode = ThemeMode.dark; // default
  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == 'light') _mode = ThemeMode.light; else if (raw == 'dark') _mode = ThemeMode.dark; else _mode = ThemeMode.system;
    notifyListeners();
  }

  Future<void> toggle() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}

class ThemeControllerScope extends InheritedWidget {
  final ThemeModeController controller;
  const ThemeControllerScope({super.key, required this.controller, required Widget child}) : super(child: child);
  static ThemeModeController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>()!.controller;
  @override
  bool updateShouldNotify(covariant ThemeControllerScope oldWidget) => oldWidget.controller != controller;
}

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.light),
    scaffoldBackgroundColor: Colors.grey[50],
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 3,
      shadowColor: Colors.black54,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
