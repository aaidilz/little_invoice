import 'package:flutter/material.dart';

/// Unified color palette derived from the DESIGN specification.
/// Uses a Material 3 surface-tonal system with a navy primary
/// and warm amber secondary accent.
abstract class AppColors {
  // ── Primary ──────────────────────────────────────────────
  static const primary = Color(0xFF04162F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF1A2B45);
  static const onPrimaryContainer = Color(0xFF8293B2);
  static const inversePrimary = Color(0xFFB6C7E8);

  static const primaryFixed = Color(0xFFD6E3FF);
  static const primaryFixedDim = Color(0xFFB6C7E8);
  static const onPrimaryFixed = Color(0xFF091C35);
  static const onPrimaryFixedVariant = Color(0xFF374763);

  // ── Secondary ────────────────────────────────────────────
  static const secondary = Color(0xFF865300);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFEA520);
  static const onSecondaryContainer = Color(0xFF694000);

  static const secondaryFixed = Color(0xFFFFDDB9);
  static const secondaryFixedDim = Color(0xFFFFB961);
  static const onSecondaryFixed = Color(0xFF2B1700);
  static const onSecondaryFixedVariant = Color(0xFF663E00);

  // ── Tertiary ─────────────────────────────────────────────
  static const tertiary = Color(0xFF201400);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF3A2702);
  static const onTertiaryContainer = Color(0xFFAA8D5E);
  static const tertiaryFixed = Color(0xFFFFDEAB);
  static const tertiaryFixedDim = Color(0xFFE3C28E);
  static const onTertiaryFixed = Color(0xFF271900);
  static const onTertiaryFixedVariant = Color(0xFF59431B);

  // ── Error ────────────────────────────────────────────────
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ── Surface / Background ─────────────────────────────────
  static const background = Color(0xFFFBF9FB);
  static const onBackground = Color(0xFF1B1B1E);

  static const surface = Color(0xFFFBF9FB);
  static const surfaceBright = Color(0xFFFBF9FB);
  static const surfaceDim = Color(0xFFDBD9DC);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF5F3F5);
  static const surfaceContainer = Color(0xFFEFEDF0);
  static const surfaceContainerHigh = Color(0xFFE9E7EA);
  static const surfaceContainerHighest = Color(0xFFE4E2E4);
  static const surfaceVariant = Color(0xFFE4E2E4);
  static const surfaceTint = Color(0xFF4E5F7C);

  static const onSurface = Color(0xFF1B1B1E);
  static const onSurfaceVariant = Color(0xFF44474D);
  static const inverseSurface = Color(0xFF303032);
  static const inverseOnSurface = Color(0xFFF2F0F3);

  // ── Outline ──────────────────────────────────────────────
  static const outline = Color(0xFF75777E);
  static const outlineVariant = Color(0xFFC5C6CE);

  // ── Status colors ────────────────────────────────────────
  static const paid = Color(0xFF16A34A);
  static const paidContainer = Color(0xFFDCFCE7);
  static const unpaid = Color(0xFFE11D48);
  static const unpaidContainer = Color(0xFFFFE4E6);
  static const draft = Color(0xFF64748B);
  static const draftContainer = Color(0xFFF1F5F9);

  // ── Custom shadow ────────────────────────────────────────
  static const customShadow = Color(0x0D1A2B45); // rgba(26,43,69,0.05)
}
