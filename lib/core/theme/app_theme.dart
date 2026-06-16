import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // ============================================================
  // LIGHT COLORS
  // ============================================================
  static const Color lightBackground = Color(0xFFF8F9FF);
  static const Color lightOnBackground = Color(0xFF0B1C30);
  static const Color lightSurface = Color(0xFFF8F9FF);
  static const Color lightSurfaceDim = Color(0xFFCBDBF5);
  static const Color lightSurfaceLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceLow = Color(0xFFEFF4FF);
  static const Color lightSurfaceContainer = Color(0xFFE5EEFF);
  static const Color lightSurfaceHigh = Color(0xFFDCE9FF);
  static const Color lightSurfaceHighest = Color(0xFFD3E4FE);
  static const Color lightSurfaceVariant = Color(0xFFD3E4FE);

  static const Color lightPrimary = Color(0xFF233953);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFF3A506B);
  static const Color lightOnPrimaryContainer = Color(0xFFABC2E2);

  static const Color lightSecondary = Color(0xFF0060AC);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFF64A8FE);
  static const Color lightOnSecondaryContainer = Color(0xFF003C70);

  static const Color lightTertiary = Color(0xFF35383A);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFF4C4F51);
  static const Color lightOnTertiaryContainer = Color(0xFFBEC1C3);

  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF93000A);

  static const Color lightOutline = Color(0xFF74777E);
  static const Color lightOutlineVariant = Color(0xFFC4C6CE);
  static const Color lightOnSurface = Color(0xFF0B1C30);
  static const Color lightOnSurfaceVariant = Color(0xFF43474D);
  static const Color lightInverseSurface = Color(0xFF213145);
  static const Color lightInverseOnSurface = Color(0xFFEAF1FF);
  static const Color lightInversePrimary = Color(0xFFB2C8E8);
  static const Color lightSurfaceTint = Color(0xFF4A607C);

  // ============================================================
  // DARK COLORS
  // ============================================================
  static const Color darkBackground = Color(0xFF131315);
  static const Color darkOnBackground = Color(0xFFE4E2E4);
  static const Color darkSurface = Color(0xFF131315);
  static const Color darkSurfaceDim = Color(0xFF131315);
  static const Color darkSurfaceLowest = Color(0xFF0E0E10);
  static const Color darkSurfaceLow = Color(0xFF1B1B1E);
  static const Color darkSurfaceContainer = Color(0xFF1F1F22);
  static const Color darkSurfaceHigh = Color(0xFF2A2A2C);
  static const Color darkSurfaceHighest = Color(0xFF353437);
  static const Color darkSurfaceVariant = Color(0xFF353437);

  static const Color darkPrimary = Color(0xFFBDC5E9);
  static const Color darkOnPrimary = Color(0xFF262F4C);
  static const Color darkPrimaryContainer = Color(0xFF1C2541);
  static const Color darkOnPrimaryContainer = Color(0xFF838CAE);

  static const Color darkSecondary = Color(0xFFB2C8E8);
  static const Color darkOnSecondary = Color(0xFF1B324B);
  static const Color darkSecondaryContainer = Color(0xFF324863);
  static const Color darkOnSecondaryContainer = Color(0xFFA0B7D6);

  static const Color darkTertiary = Color(0xFFBFC5E4);
  static const Color darkOnTertiary = Color(0xFF292F48);
  static const Color darkTertiaryContainer = Color(0xFF1F253D);
  static const Color darkOnTertiaryContainer = Color(0xFF868CA9);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  static const Color darkOutline = Color(0xFF909098);
  static const Color darkOutlineVariant = Color(0xFF45464D);
  static const Color darkOnSurface = Color(0xFFE4E2E4);
  static const Color darkOnSurfaceVariant = Color(0xFFC6C6CE);
  static const Color darkInverseSurface = Color(0xFFE4E2E4);
  static const Color darkInverseOnSurface = Color(0xFF303032);
  static const Color darkInversePrimary = Color(0xFF545D7C);
  static const Color darkSurfaceTint = Color(0xFFBDC5E9);

  // ============================================================
  // SPACING / RADIUS
  // ============================================================
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;

  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radiusFull = 9999;

  // ============================================================
  // COLOR SCHEMES
  // ============================================================
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: lightOnPrimaryContainer,
    secondary: lightSecondary,
    onSecondary: lightOnSecondary,
    secondaryContainer: lightSecondaryContainer,
    onSecondaryContainer: lightOnSecondaryContainer,
    tertiary: lightTertiary,
    onTertiary: lightOnTertiary,
    tertiaryContainer: lightTertiaryContainer,
    onTertiaryContainer: lightOnTertiaryContainer,
    error: lightError,
    onError: lightOnError,
    errorContainer: lightErrorContainer,
    onErrorContainer: lightOnErrorContainer,
    surface: lightSurface,
    onSurface: lightOnSurface,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightOutline,
    outlineVariant: lightOutlineVariant,
    inverseSurface: lightInverseSurface,
    onInverseSurface: lightInverseOnSurface,
    inversePrimary: lightInversePrimary,
    surfaceTint: lightSurfaceTint,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: darkOnPrimaryContainer,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    error: darkError,
    onError: darkOnError,
    errorContainer: darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    surface: darkSurface,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
    outlineVariant: darkOutlineVariant,
    inverseSurface: darkInverseSurface,
    onInverseSurface: darkInverseOnSurface,
    inversePrimary: darkInversePrimary,
    surfaceTint: darkSurfaceTint,
  );

  // ============================================================
  // TEXT THEMES
  // ============================================================
  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      displayLarge: GoogleFonts.manrope(
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.96,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.32,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.28,
        color: textColor,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        color: textColor,
      ),
    );
  }

  // ============================================================
  // LIGHT THEME
  // ============================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightBackground,
      textTheme: _textTheme(lightOnSurface),

      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightOnSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightOnSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.65),
        elevation: 0,
        shadowColor: const Color(0xFF1F2687).withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space16,
          vertical: space16,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: lightOutline,
        ),
        labelStyle: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.28,
          color: lightPrimary,
        ),
        prefixIconColor: lightOutline,
        suffixIconColor: lightOutline,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: BorderSide(
            color: const Color(0xFFBAC8E2).withOpacity(0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: BorderSide(
            color: const Color(0xFFBAC8E2).withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(
            color: lightPrimaryContainer,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: lightError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: lightError, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryContainer,
          foregroundColor: lightOnPrimary,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shadowColor: lightPrimary.withOpacity(0.10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius12),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return lightPrimary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(lightOnPrimary),
        side: const BorderSide(
          color: lightOutlineVariant,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius4),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightInverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: lightInverseOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius12),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: lightOutlineVariant.withOpacity(0.4),
        thickness: 1,
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkBackground,
      textTheme: _textTheme(darkOnSurface),

      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.05),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space16,
          vertical: space16,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: darkOutline,
        ),
        labelStyle: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.28,
          color: darkPrimary,
        ),
        prefixIconColor: darkOnSurfaceVariant,
        suffixIconColor: darkOnSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: BorderSide(
            color: darkPrimary.withOpacity(0.5),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: darkError, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryContainer,
          foregroundColor: darkOnPrimary,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shadowColor: darkPrimary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius12),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return darkPrimary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(darkOnPrimary),
        side: const BorderSide(
          color: darkOutlineVariant,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius4),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkInverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: darkInverseOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius12),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: darkOutlineVariant.withOpacity(0.4),
        thickness: 1,
      ),
    );
  }
}

// ============================================================
// OPTIONAL: quick access helpers
// ============================================================
extension AppThemeContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}