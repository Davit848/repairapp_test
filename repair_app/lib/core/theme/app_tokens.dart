import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Spacing on the 4/8px grid.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  static const screen = EdgeInsets.symmetric(horizontal: md);
}

/// Squircle radii.
abstract final class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(6));
  static const md = BorderRadius.all(Radius.circular(10));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(24));
  static const pill = BorderRadius.all(Radius.circular(999));
}

/// Crisp, sunlight-safe elevation levels.
abstract final class AppShadows {
  static const level1 = [
    BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0A0F172A), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const level2 = [
    BoxShadow(color: Color(0x140F172A), offset: Offset(0, 4), blurRadius: 12, spreadRadius: -2),
    BoxShadow(color: Color(0x0A0F172A), offset: Offset(0, 2), blurRadius: 6, spreadRadius: -1),
  ];

  static const level3 = [
    BoxShadow(color: Color(0x1F0F172A), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
    BoxShadow(color: Color(0x0A0F172A), offset: Offset(0, 10), blurRadius: 10, spreadRadius: -5),
  ];
}

abstract final class AppDecorations {
  static const card = BoxDecoration(
    color: AppColors.card,
    borderRadius: AppRadius.xl,
    border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
    boxShadow: AppShadows.level1,
  );
}
