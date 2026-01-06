import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS-style theme following Apple Human Interface Guidelines
/// Implements Liquid Glass / iOS 17+ visual style
class IOSTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF007AFF); // iOS Blue
  static const Color accentColor = Color(0xFF34C759); // iOS Green (for fan)
  static const Color dangerColor = Color(0xFFFF3B30); // iOS Red

  // iOS semantic colors (light mode)
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color secondaryBackgroundLight = Color(0xFFF2F2F7);
  static const Color tertiaryBackgroundLight = Color(0xFFFFFFFF);
  static const Color labelLight = Color(0xFF000000);
  static const Color secondaryLabelLight = Color(0xFF3C3C43);
  static const Color separatorLight = Color(0x4C3C3C43);

  // iOS semantic colors (dark mode)
  static const Color backgroundDark = Color(0xFF000000);
  static const Color secondaryBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiaryBackgroundDark = Color(0xFF2C2C2E);
  static const Color labelDark = Color(0xFFFFFFFF);
  static const Color secondaryLabelDark = Color(0xFFEBEBF5);
  static const Color separatorDark = Color(0x99545458);

  // Spacing scale (iOS standard)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Corner radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // Typography scale (iOS standard)
  static const String fontFamily = 'SF Pro Text'; // Use system font fallback

  static TextTheme get textTheme => const TextTheme(
        // Large Title - 34pt bold
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.37,
          height: 1.2,
        ),
        // Title 1 - 28pt regular
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.36,
          height: 1.25,
        ),
        // Title 2 - 22pt regular
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.35,
          height: 1.27,
        ),
        // Headline - 17pt semibold
        headlineMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.41,
          height: 1.29,
        ),
        // Body - 17pt regular
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.41,
          height: 1.29,
        ),
        // Callout - 16pt regular
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.32,
          height: 1.31,
        ),
        // Footnote - 13pt regular
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.08,
          height: 1.33,
        ),
        // Caption - 12pt regular
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
          height: 1.33,
        ),
      );

  // Light theme
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryBackgroundLight,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: backgroundLight,
          error: dangerColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: labelLight,
        ),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryBackgroundLight.withValues(alpha: 0.9),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: textTheme.displaySmall?.copyWith(
            color: labelLight,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
        cardTheme: CardThemeData(
          color: backgroundLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: tertiaryBackgroundLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: backgroundLight,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryLabelLight,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        dividerTheme: const DividerThemeData(
          color: separatorLight,
          thickness: 0.5,
        ),
      );

  // Dark theme
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: accentColor,
          surface: secondaryBackgroundDark,
          error: dangerColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: labelDark,
        ),
        textTheme: textTheme.apply(
          bodyColor: labelDark,
          displayColor: labelDark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundDark.withValues(alpha: 0.9),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: textTheme.displaySmall?.copyWith(
            color: labelDark,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
        cardTheme: CardThemeData(
          color: secondaryBackgroundDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: tertiaryBackgroundDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: secondaryBackgroundDark,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryLabelDark,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        dividerTheme: const DividerThemeData(
          color: separatorDark,
          thickness: 0.5,
        ),
      );

  // Cupertino theme (for iOS-specific widgets)
  static CupertinoThemeData get cupertinoTheme => const CupertinoThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryBackgroundLight,
        barBackgroundColor: backgroundLight,
        textTheme: CupertinoTextThemeData(
          primaryColor: labelLight,
        ),
      );
}
