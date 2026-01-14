import 'package:flutter/material.dart';

/// Smart Home App Design System
/// Extracted from Figma assets - Material 3 Implementation
///
/// Color Palette:
/// - Primary: Amber/Gold (#D4A84B) - copper/bronze pendant light tones
/// - Background: Dark with golden overlay
/// - Surface: Semi-transparent dark (glassmorphism)
/// - Text: White and white70

class AppColors {
  AppColors._();

  // Primary colors - Amber/Gold tones from pendant lights
  static const Color primary = Color(0xFFD4A84B);
  static const Color primaryLight = Color(0xFFE8C97D);
  static const Color primaryDark = Color(0xFFB08930);

  // Secondary accent
  static const Color secondary = Color(0xFFFFB347);

  // Background colors
  static const Color background = Color(0xFF1A1A1A);
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF2A2A2A);

  // Glassmorphism surface
  static const Color glassSurface = Color(0xB0000000); // 70% opacity
  static const Color glassBorder = Color(0x50FFFFFF); // 30% opacity

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textMuted = Color(0x80FFFFFF); // 50% white

  // Status colors for fan speeds
  static const Color speedSlow = Color(0xFFFF5252); // Red
  static const Color speedMedium = Color(0xFF448AFF); // Blue
  static const Color speedFast = Color(0xFF4CAF50); // Green

  // Functional colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}

class AppTypography {
  AppTypography._();

  // Display - for "HOME" branding
  static const TextStyle displayLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 4,
  );

  // Display small - for "SMART" subtitle
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 6,
  );

  // Headline - for temperature values
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Title - for section headers
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body - for regular text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Label - for small labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(xl));
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.backgroundDark,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textPrimary,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.glassSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
          side: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.glassBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.glassBorder,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.glassBorder;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textMuted;
        }),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.titleLarge,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
    );
  }
}

/// Background gradient decoration for screens
class AppGradients {
  AppGradients._();

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2A2410), // Dark amber top
      Color(0xFF1A1A1A), // Dark bottom
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryLight,
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );

  static BoxDecoration get dashboardBackground => const BoxDecoration(
    gradient: backgroundGradient,
  );
}
