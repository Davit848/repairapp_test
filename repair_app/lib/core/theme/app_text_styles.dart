import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale: Plus Jakarta Sans for display/headlines, Inter for body/data.
abstract final class AppTextStyles {
  static TextStyle _jakarta(double size, FontWeight weight, double height, double spacing) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        height: height / size,
        letterSpacing: size * spacing,
        color: AppColors.text,
      );

  static TextStyle _inter(double size, FontWeight weight, double height, double spacing) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    height: height / size,
    letterSpacing: size * spacing,
    color: AppColors.text,
  );

  static final displayLg = _jakarta(40, FontWeight.w800, 48, -0.02);
  static final headlineLg = _jakarta(26, FontWeight.w700, 32, -0.01);
  static final headlineMd = _jakarta(24, FontWeight.w700, 32, -0.01);
  static final headlineSm = _jakarta(20, FontWeight.w600, 28, 0);

  static final titleLg = _inter(18, FontWeight.w600, 26, -0.01);
  static final titleMd = _inter(16, FontWeight.w600, 24, 0);

  static final bodyLg = _inter(16, FontWeight.w400, 24, 0);
  static final bodyMd = _inter(14, FontWeight.w400, 20, 0);
  static final bodySm = _inter(12, FontWeight.w400, 16, 0.01);

  static final labelLg = _inter(14, FontWeight.w600, 20, 0.01);
  static final labelMd = _inter(12, FontWeight.w600, 16, 0.02);
  static final labelSm = _inter(10, FontWeight.w700, 14, 0.05);

  /// Bold tabular figures for prices, stock counts and telemetry.
  static final price = _jakarta(
    22,
    FontWeight.w800,
    28,
    -0.01,
  ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
