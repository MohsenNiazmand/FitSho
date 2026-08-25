import 'package:flutter/material.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';

abstract final class AppFonts {
  static const String family = 'Vazirmatn';
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: cPrimary,
      onPrimary: Colors.white,
      primaryContainer: cSurfaceElevated,
      onPrimaryContainer: cPrimaryDark,
      secondary: cSecondary,
      onSecondary: Colors.white,
      secondaryContainer: cSecondaryContainer,
      onSecondaryContainer: cSecondary,
      tertiary: cPrimaryLight,
      onTertiary: Colors.white,
      error: cError,
      onError: Colors.white,
      surface: cSurface,
      onSurface: cTextPrimary,
      onSurfaceVariant: cTextSecondary,
      outline: cBorder,
      outlineVariant: cDivider,
      surfaceContainerHighest: cSurfaceElevated,
      surfaceContainerHigh: Color(0xFFFFF4EB),
      surfaceContainer: cBackground,
      surfaceContainerLow: cBackground,
      surfaceContainerLowest: cSurface,
    );

    final textTheme = _textTheme(cTextPrimary, cTextSecondary);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.family,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cBackground,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: cSurface,
        foregroundColor: cTextPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: cTextPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cSurface,
        elevation: 0,
        shadowColor: Color(0x1A1C1412),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cSurface,
        elevation: 2,
        height: 72,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? colorScheme.primary : cTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : cTextSecondary,
            size: 24,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: cBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: cBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: cPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: cError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: cError, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: cTextSecondary),
        labelStyle: textTheme.bodyMedium?.copyWith(color: cTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: cPrimary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          side: const BorderSide(color: cBorder),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cPrimary,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: cDivider,
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
        side: const BorderSide(color: cBorder),
        showCheckmark: true,
        checkmarkColor: cPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: cDivider,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: cPrimary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cTextPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyLarge,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: cTextSecondary,
        textColor: cTextPrimary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    TextStyle base(double size, FontWeight weight, double height) {
      return TextStyle(
        fontFamily: AppFonts.family,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: 0,
        color: primary,
      );
    }

    return TextTheme(
      displayLarge: base(32, FontWeight.w700, 1.35),
      displayMedium: base(28, FontWeight.w700, 1.35),
      displaySmall: base(24, FontWeight.w700, 1.4),
      headlineLarge: base(24, FontWeight.w700, 1.4),
      headlineMedium: base(22, FontWeight.w600, 1.4),
      headlineSmall: base(20, FontWeight.w600, 1.45),
      titleLarge: base(18, FontWeight.w600, 1.45),
      titleMedium: base(16, FontWeight.w600, 1.5),
      titleSmall: base(14, FontWeight.w600, 1.5),
      bodyLarge: base(16, FontWeight.w400, 1.65),
      bodyMedium: base(14, FontWeight.w400, 1.65).copyWith(color: secondary),
      bodySmall: base(12, FontWeight.w400, 1.6).copyWith(color: secondary),
      labelLarge: base(14, FontWeight.w600, 1.4),
      labelMedium: base(12, FontWeight.w500, 1.4),
      labelSmall: base(11, FontWeight.w500, 1.35).copyWith(color: secondary),
    );
  }
}
