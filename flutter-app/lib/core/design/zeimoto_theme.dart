import 'package:flutter/material.dart';

/// Minimal organic Japanese palette shared across all prototype variants.
class ZeimotoColors {
  static const washi = Color(0xFFF5F1E8);
  static const washiDeep = Color(0xFFEBE4D2);
  static const sage = Color(0xFF8FA68E);
  static const moss = Color(0xFF5C7361);
  static const charcoal = Color(0xFF2E2E2E);
  static const charcoalSoft = Color(0xFF6B6B6B);
  static const cinnabar = Color(0xFFB94E3F);
}

/// Layout and spacing constants for Zeimoto.
class ZeimotoSpacing {
  /// Fixed height of the pinned agent bar.
  static const double agentBarHeight = 60.0;

  /// Shadow colour for the agent bar elevation.
  static const Color agentBarShadowColor = Color(0x0D2E2E2E); // charcoal @ 5%
}

class ZeimotoTheme {
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: ZeimotoColors.washi,
      colorScheme: base.colorScheme.copyWith(
        primary: ZeimotoColors.moss,
        secondary: ZeimotoColors.sage,
        surface: ZeimotoColors.washi,
        onSurface: ZeimotoColors.charcoal,
      ),
      textTheme: base.textTheme
          .apply(
            bodyColor: ZeimotoColors.charcoal,
            displayColor: ZeimotoColors.charcoal,
          )
          .copyWith(
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.5,
              color: ZeimotoColors.charcoal,
            ),
            headlineMedium: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: ZeimotoColors.charcoal,
            ),
            titleMedium: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ZeimotoColors.charcoal,
            ),
            bodyMedium: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: ZeimotoColors.charcoalSoft,
            ),
            labelSmall: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
              color: ZeimotoColors.charcoalSoft.withValues(alpha: 0.9),
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ZeimotoColors.washi,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ZeimotoColors.charcoal,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: ZeimotoColors.washiDeep,
          disabledForegroundColor: ZeimotoColors.charcoalSoft,
        ),
      ),
    );
  }
}
