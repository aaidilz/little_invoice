import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get h2 => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get labelBold => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.5,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get statDisplay => GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 34 / 28,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.5,
        color: const Color(0xFF44474D),
      );

  static TextStyle get headline => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: const Color(0xFF1B1B1E),
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: const Color(0xFF44474D),
      );

  static TextStyle get display => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        color: const Color(0xFF1B1B1E),
      );
}
