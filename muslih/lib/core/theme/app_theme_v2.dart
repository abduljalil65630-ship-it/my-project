import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

// --- Locale Provider ----------------------------------------------------------
final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class LocaleController {
  final Reader _read;
  LocaleController(this._read);

  void setLocale(String code) {
    _read(localeProvider.notifier).state = Locale(code);
  }

  void toggleTheme() {
    final current = _read(themeModeProvider).state;
    _read(themeModeProvider.notifier).state =
        current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final localeControllerProvider = Provider<LocaleController>((ref) {
  return LocaleController(ref.read);
});

// --- Localizations Delegate ---------------------------------------------------
class AppLocalizationsDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) async {
    // We use static strings in S class
    return S._();
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// --- Theming ------------------------------------------------------------------
class AppColors {
  const AppColors._();
  static const Color primary = Color(0xFF1E6B5A);
  static const Color primaryLight = Color(0xFFE3F0EC);
  static const Color accent = Color(0xFFF2A900);
  static const Color background = Color(0xFFF7F9F8);
  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color error = Color(0xFFD14343);
  static const Color success = Color(0xFF2E9E5B);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
}

class AppDarkColors {
  const AppDarkColors._();
  static const Color primary = Color(0xFF34D399);
  static const Color primaryLight = Color(0xFF064E3B);
  static const Color accent = Color(0xFFFBBF24);
  static const Color background = Color(0xFF111827);
  static const Color textDark = Color(0xFFF9FAFB);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color error = Color(0xFFF87171);
  static const Color success = Color(0xFF34D399);
  static const Color card = Color(0xFF1F2937);
  static const Color border = Color(0xFF374151);
}

class AppThemes {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: AppColors.primary,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200),
      fontFamily: 'Cairo',
    );
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: AppDarkColors.primary,
      primaryColor: AppDarkColors.primary,
      scaffoldBackgroundColor: AppDarkColors.background,
      cardTheme: CardTheme(
        color: AppDarkColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDarkColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppDarkColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppDarkColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppDarkColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppDarkColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDarkColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppDarkColors.card,
        foregroundColor: AppDarkColors.textDark,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppDarkColors.card,
        selectedItemColor: AppDarkColors.primary,
        unselectedItemColor: AppDarkColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      fontFamily: 'Cairo',
    );
  }
}
