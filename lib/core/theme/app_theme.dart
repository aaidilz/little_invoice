import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Central theme definition matching the Invoicely DESIGN spec.
///
/// All spacing, radius, and token constants live here so screens
/// reference a single source of truth.
class AppTheme {
  // ── Spacing tokens (match DESIGN spacing) ────────────────
  static const double space2 = 2;
  static const double space4 = 4;   // base
  static const double space8 = 8;   // xs
  static const double space12 = 12; // sm / gutter
  static const double space16 = 16; // md / safe-margin
  static const double space20 = 20;
  static const double space24 = 24; // lg
  static const double space32 = 32; // xl
  static const double space100 = 100;

  // ── Radius tokens ────────────────────────────────────────
  static const double radiusCard = 12;   // rounded-xl
  static const double radiusInput = 12;
  static const double radiusButton = 12;
  static const double radiusFab = 28;
  static const double radiusBadge = 20;
  static const double radiusChip = 8;
  static const double radiusSmall = 8;

  // ── Custom shadow ────────────────────────────────────────
  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: AppColors.customShadow,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get bottomBarShadow => const [
        BoxShadow(
          color: AppColors.customShadow,
          blurRadius: 12,
          offset: Offset(0, -4),
        ),
      ];

  // ── Theme Data ───────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.onTertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          onTertiaryContainer: AppColors.onTertiaryContainer,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          surfaceContainerHigh: AppColors.surfaceContainerHigh,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerLow: AppColors.surfaceContainerLow,
          surfaceContainerLowest: AppColors.surfaceContainerLowest,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          error: AppColors.error,
          onError: AppColors.onError,
          errorContainer: AppColors.errorContainer,
          onErrorContainer: AppColors.onErrorContainer,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.inversePrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,

        // ── AppBar ───────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: AppTextStyles.h1.copyWith(color: AppColors.primary),
          iconTheme: const IconThemeData(color: AppColors.primary),
          centerTitle: false,
        ),

        // ── Text ─────────────────────────────────────────────
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          titleMedium: AppTextStyles.title,
          bodyLarge: AppTextStyles.bodyLg,
          bodyMedium: AppTextStyles.bodyMd,
          bodySmall: AppTextStyles.caption,
          labelMedium: AppTextStyles.labelBold,
          labelSmall: AppTextStyles.caption,
        ),

        // ── Card ─────────────────────────────────────────────
        cardTheme: CardThemeData(
          elevation: 0,
          shadowColor: AppColors.customShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard),
            side: const BorderSide(
              color: AppColors.surfaceContainer,
              width: 1,
            ),
          ),
          color: AppColors.surfaceContainerLowest,
          margin: EdgeInsets.zero,
        ),

        // ── Input ────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(
              color: AppColors.primaryContainer,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          labelStyle: AppTextStyles.labelBold.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          hintStyle: AppTextStyles.bodyMd.copyWith(
            color: AppColors.outline,
          ),
          errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
          floatingLabelStyle: AppTextStyles.labelBold.copyWith(
            color: AppColors.primaryContainer,
          ),
        ),

        // ── Elevated Button ──────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(0, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
            textStyle: AppTextStyles.labelBold,
            elevation: 0,
          ),
        ),

        // ── Outlined Button ──────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(0, 56),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
            textStyle: AppTextStyles.labelBold,
          ),
        ),

        // ── Text Button ──────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.labelBold,
          ),
        ),

        // ── FAB ──────────────────────────────────────────────
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFab),
          ),
        ),

        // ── Bottom Nav ───────────────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),

        // ── Divider ──────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineVariant,
          thickness: 1,
          space: 1,
        ),

        // ── Dialog ───────────────────────────────────────────
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.surfaceContainerLowest,
        ),

        // ── SnackBar ─────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          backgroundColor: AppColors.inverseSurface,
          contentTextStyle: AppTextStyles.bodyMd.copyWith(
            color: AppColors.inverseOnSurface,
          ),
        ),

        // ── Chip ─────────────────────────────────────────────
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
        ),

        // ── Bottom Sheet ─────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),

        // ── ProgressIndicator ────────────────────────────────
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryContainer,
        ),
      );
}
