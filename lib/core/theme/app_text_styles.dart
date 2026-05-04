import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static TextStyle get display => GoogleFonts.nunitoSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get headline => GoogleFonts.nunitoSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle get title => GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get body => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get label => GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle get caption => GoogleFonts.nunitoSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFF6E7D8A),
  );
}
