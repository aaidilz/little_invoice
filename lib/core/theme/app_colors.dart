import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF6750A4);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFEADDFF);
  static const onPrimaryContainer = Color(0xFF21005D);
  static const inversePrimary = Color(0xFFDEA7FF);

  static const secondary = Color(0xFF00BFA5);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFB7FFF5);
  static const onSecondaryContainer = Color(0xFF00201F);

  static const tertiary = Color(0xFF8A56AC);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFE8DEFF);
  static const onTertiaryContainer = Color(0xFF2D0F49);

  static const error = Color(0xFFB00020);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF37000B);

  static const primaryFixed = Color(0xFFEAD9FF);
  static const primaryFixedDim = Color(0xFFD4BDFE);
  static const onPrimaryFixed = Color(0xFF2B0056);
  static const onPrimaryFixedVariant = Color(0xFF4B3677);

  static const secondaryFixed = Color(0xFFBFFFF8);
  static const secondaryFixedDim = Color(0xFF74DFD6);
  static const onSecondaryFixed = Color(0xFF003733);
  static const onSecondaryFixedVariant = Color(0xFF006963);

  static const tertiaryFixed = Color(0xFFEDD7FF);
  static const tertiaryFixedDim = Color(0xFFD2B5FF);
  static const onTertiaryFixed = Color(0xFF350056);
  static const onTertiaryFixedVariant = Color(0xFF5B3C8B);

  static const background = Color(0xFFF6F1FF);
  static const onBackground = Color(0xFF1B0D30);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0E7FF);
  static const onSurface = Color(0xFF1B0D30);
  static const onSurfaceVariant = Color(0xFF4D2A7A);
  static const outline = Color(0xFFB59FE1);

  // Status colors (from DESIGN.md description)
  static const paid = Color(0xFF2E7D32); // Emerald green
  static const paidContainer = Color(0xFFE8F5E9);
  static const unpaid = Color(0xFFE65100); // Rose/Amber
  static const unpaidContainer = Color(0xFFFFF3E0);
  static const draft = Color(0xFF6E7D8A); // Slate gray
  static const draftContainer = Color(0xFFF5F5F5);
}
