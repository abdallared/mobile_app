import 'package:flutter/material.dart';

class HabitFlowColors {
  // Primary
  static const Color primary = Color(0xFF4648D4);
  static const Color primaryContainer = Color(0xFF6063EE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);
  static const Color primaryFixed = Color(0xFFE1E0FF);
  static const Color primaryFixedDim = Color(0xFFC0C1FF);
  static const Color inversePrimary = Color(0xFFC0C1FF);

  // Secondary
  static const Color secondary = Color(0xFF6B38D4);
  static const Color secondaryContainer = Color(0xFF8455EF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFFFFFBFF);
  static const Color secondaryFixed = Color(0xFFE9DDFF);
  static const Color secondaryFixedDim = Color(0xFFD0BCFF);

  // Tertiary
  static const Color tertiary = Color(0xFF006577);
  static const Color tertiaryContainer = Color(0xFF008096);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFF9FDFF);
  static const Color tertiaryFixed = Color(0xFFACEDFF);
  static const Color tertiaryFixedDim = Color(0xFF4CD7F6);

  // Surface
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceDim = Color(0xFFD8DADC);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color surfaceVariant = Color(0xFFE0E3E5);
  static const Color surfaceTint = Color(0xFF494BD6);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF464554);
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F3);

  // Background
  static const Color background = Color(0xFFF7F9FB);
  static const Color onBackground = Color(0xFF191C1E);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Outline
  static const Color outline = Color(0xFF767586);
  static const Color outlineVariant = Color(0xFFC7C4D7);

  // Extra accent colors
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
}

class HabitFlowTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: HabitFlowColors.primary,
        primaryContainer: HabitFlowColors.primaryContainer,
        onPrimary: HabitFlowColors.onPrimary,
        onPrimaryContainer: HabitFlowColors.onPrimaryContainer,
        secondary: HabitFlowColors.secondary,
        secondaryContainer: HabitFlowColors.secondaryContainer,
        onSecondary: HabitFlowColors.onSecondary,
        onSecondaryContainer: HabitFlowColors.onSecondaryContainer,
        tertiary: HabitFlowColors.tertiary,
        tertiaryContainer: HabitFlowColors.tertiaryContainer,
        onTertiary: HabitFlowColors.onTertiary,
        onTertiaryContainer: HabitFlowColors.onTertiaryContainer,
        surface: HabitFlowColors.surface,
        onSurface: HabitFlowColors.onSurface,
        onSurfaceVariant: HabitFlowColors.onSurfaceVariant,
        error: HabitFlowColors.error,
        onError: HabitFlowColors.onError,
        errorContainer: HabitFlowColors.errorContainer,
        onErrorContainer: HabitFlowColors.onErrorContainer,
        outline: HabitFlowColors.outline,
        outlineVariant: HabitFlowColors.outlineVariant,
        inverseSurface: HabitFlowColors.inverseSurface,
        onInverseSurface: HabitFlowColors.inverseOnSurface,
        inversePrimary: HabitFlowColors.inversePrimary,
        surfaceTint: HabitFlowColors.surfaceTint,
      ),
      scaffoldBackgroundColor: HabitFlowColors.surface,
      // textTheme: GoogleFonts.interTextTheme(),
      // fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
}

// Glassmorphism decoration helper
class GlassDecoration {
  static BoxDecoration card({
    double opacity = 0.25,
    double borderRadius = 24,
    double borderOpacity = 0.4,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: HabitFlowColors.primary.withValues(alpha: 0.05),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration elevated({
    double borderRadius = 24,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border(
        top: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
        left: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
        right: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      boxShadow: [
        BoxShadow(
          color: HabitFlowColors.primary.withValues(alpha: 0.15),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

// Gradient helpers
class HabitFlowGradients {
  static const LinearGradient primaryToSecondary = LinearGradient(
    colors: [HabitFlowColors.primary, HabitFlowColors.secondary],
  );

  static const LinearGradient cyanToIndigo = LinearGradient(
    colors: [HabitFlowColors.tertiaryFixedDim, HabitFlowColors.primary],
  );

  static const LinearGradient splashBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      HabitFlowColors.primary,
      HabitFlowColors.primaryContainer,
      HabitFlowColors.secondary,
    ],
  );
}
