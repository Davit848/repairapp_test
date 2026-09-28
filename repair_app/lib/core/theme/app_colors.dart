import 'package:flutter/material.dart';

/// Color tokens from the "Utilitarian Kinetic Workshop" design system.
abstract final class AppColors {
  // Industrial deep slate — chrome, headers, dark actions.
  static const slate = Color(0xFF0F172A);
  static const slateSoft = Color(0xFF1E293B);

  // Safety road amber — primary CTAs, live status, warnings.
  static const amber = Color(0xFFEA580C);
  static const amberBright = Color(0xFFFD651E);
  static const amberDeep = Color(0xFFA73A00);
  static const amberSoft = Color(0xFFFFDBCE);
  static const amberWash = Color(0xFFFFF1EB);

  // Precision diagnostic blue — verification, telemetry, links.
  static const blue = Color(0xFF2563EB);
  static const blueSoft = Color(0xFFDBE1FF);

  // Semantic accents.
  static const emerald = Color(0xFF10B981);
  static const emeraldSoft = Color(0xFFECFDF5);
  static const emeraldText = Color(0xFF065F46);
  static const danger = Color(0xFFDC2626);
  static const dangerSoft = Color(0xFFFFDAD6);

  // Surfaces.
  static const surface = Color(0xFFF8F9FF);
  static const card = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFEFF4FF);
  static const surfaceMid = Color(0xFFE5EEFF);
  static const surfaceHigh = Color(0xFFDCE9FF);

  // Lines & text.
  static const border = Color(0xFFE2E8F0);
  static const inputBorder = Color(0xFFCBD5E1);
  static const steel = Color(0xFF64748B);
  static const text = Color(0xFF0B1C30);
  static const textMuted = Color(0xFF45464D);

  // Static map illustration.
  static const mapLand = Color(0xFFE8EEF8);
  static const mapPark = Color(0xFFD7EBDC);
  static const mapWater = Color(0xFFC4DAF7);
  static const mapRoadMajor = Color(0xFFF6A45E);
}
