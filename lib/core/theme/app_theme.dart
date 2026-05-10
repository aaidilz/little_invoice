import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space100 = 100;

  static const double radiusSm = 4;
  static const double radiusSmall = 4;
  static const double radiusDefault = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  static const double radiusCard = 8;
  static const double radiusInput = 8;
  static const double radiusButton = 8;
  static const double radiusFab = 16;
  static const double radiusBadge = 16;
  static const double radiusChip = 9999;

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D04162F),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> bottomBarShadow = [
    BoxShadow(
      color: Color(0x0D04162F),
      blurRadius: 16,
      offset: Offset(0, -2),
    ),
  ];

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          surface: AppColors.background,
          onSurface: AppColors.onBackground,
          surfaceContainerLowest: AppColors.surfaceContainerLowest,
          surfaceContainerLow: AppColors.surfaceContainerLow,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerHigh: AppColors.surfaceContainerHigh,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        textTheme: TextTheme(
          displayMedium: AppTextStyles.h2,
          headlineMedium: AppTextStyles.h1,
          titleMedium: AppTextStyles.title,
          bodyMedium: AppTextStyles.bodyMd,
          labelMedium: AppTextStyles.labelBold,
          bodySmall: AppTextStyles.bodyMd,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard),
            side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          color: AppColors.surface,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.outline, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          labelStyle: AppTextStyles.labelBold.copyWith(color: AppColors.onSurfaceVariant),
          errorStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.error),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(0, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
            textStyle: AppTextStyles.title,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(0, 56),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
            textStyle: AppTextStyles.title,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: StadiumBorder(),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Color(0xFF75777E),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineVariant,
          thickness: 1,
          space: 1,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.h1,
          iconTheme: const IconThemeData(color: AppColors.onBackground),
          centerTitle: false,
        ),
      );
}
