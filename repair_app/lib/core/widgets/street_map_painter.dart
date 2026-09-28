import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Stylized Phnom Penh street illustration used instead of a live map SDK.
///
/// All geometry is expressed in normalized (0–1) coordinates of [viewport],
/// so pins positioned with the same mapping line up with the streets.
class StreetMapPainter extends CustomPainter {
  const StreetMapPainter({this.viewport, this.routeFrom, this.routeTo, this.showLabels = true});

  /// Area the normalized coordinates map into. Defaults to the full canvas.
  final Rect? viewport;
  final Offset? routeFrom;
  final Offset? routeTo;
  final bool showLabels;

  static const _majorRoads = [
    [Offset(0.29, -0.2), Offset(0.30, 0.55), Offset(0.33, 1.4)],
    [Offset(-0.1, 0.49), Offset(0.45, 0.46), Offset(0.80, 0.47)],
  ];

  static const _minorRoads = [
    [Offset(0.06, 0.12), Offset(0.35, 0.30), Offset(0.60, 0.36), Offset(0.84, 0.39)],
    [Offset(-0.1, 0.28), Offset(0.84, 0.30)],
    [Offset(0.38, -0.2), Offset(0.39, 1.4)],
    [Offset(0.65, -0.2), Offset(0.66, 1.4)],
    [Offset(-0.1, 0.70), Offset(0.82, 0.66)],
    [Offset(0.05, 1.05), Offset(0.40, 0.92), Offset(0.92, 0.90)],
    [Offset(0.00, 0.87), Offset(0.30, 0.95), Offset(0.64, 1.18)],
  ];

  static const _parks = [
    Rect.fromLTWH(0.10, 0.22, 0.14, 0.18),
    Rect.fromLTWH(0.52, 0.60, 0.16, 0.14),
    Rect.fromLTWH(0.18, 1.05, 0.14, 0.2),
  ];

  static const _labels = {
    'BOENG KENG KANG': Offset(0.15, 0.40),
    'TUOL TOM POUNG': Offset(0.43, 0.87),
    'ST. 271': Offset(0.17, 0.78),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final frame = viewport ?? Offset.zero & size;
    Offset p(Offset n) => Offset(frame.left + n.dx * frame.width, frame.top + n.dy * frame.height);

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.mapLand);

    final parkPaint = Paint()..color = AppColors.mapPark;
    for (final park in _parks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromPoints(p(park.topLeft), p(park.bottomRight)), const Radius.circular(24)),
        parkPaint,
      );
    }

    // Tonle Sap riverbank along the east edge.
    final river = Path()
      ..moveTo(p(const Offset(0.86, -0.2)).dx, 0)
      ..cubicTo(
        p(const Offset(0.80, 0.3)).dx,
        p(const Offset(0.80, 0.3)).dy,
        p(const Offset(0.92, 0.6)).dx,
        p(const Offset(0.92, 0.6)).dy,
        p(const Offset(0.86, 1.4)).dx,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(river, Paint()..color = AppColors.mapWater);

    _drawRoads(canvas, _minorRoads, p, casing: AppColors.border, fill: Colors.white, width: 9);
    _drawRoads(canvas, _majorRoads, p, casing: AppColors.mapRoadMajor, fill: const Color(0xFFFFD2A8), width: 10);

    if (showLabels) {
      _labels.forEach((text, at) => _drawLabel(canvas, text, p(at)));
    }

    if (routeFrom != null && routeTo != null) {
      _drawRoute(canvas, p(routeFrom!), p(routeTo!));
    }
  }

  void _drawRoads(
    Canvas canvas,
    List<List<Offset>> roads,
    Offset Function(Offset) p, {
    required Color casing,
    required Color fill,
    required double width,
  }) {
    final casingPaint = Paint()
      ..color = casing
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width + 3;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width - 3;

    for (final road in roads) {
      final path = Path()..moveTo(p(road.first).dx, p(road.first).dy);
      for (final point in road.skip(1)) {
        path.lineTo(p(point).dx, p(point).dy);
      }
      canvas
        ..drawPath(path, casingPaint)
        ..drawPath(path, fillPaint);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppColors.steel, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  void _drawRoute(Canvas canvas, Offset from, Offset to) {
    final control = Offset(from.dx, to.dy + (from.dy - to.dy) * 0.35);
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);

    final dashed = Path();
    for (final ui.PathMetric metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 12) {
        dashed.addPath(metric.extractPath(d, d + 7), Offset.zero);
      }
    }
    canvas.drawPath(
      dashed,
      Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(StreetMapPainter oldDelegate) =>
      oldDelegate.viewport != viewport ||
      oldDelegate.routeFrom != routeFrom ||
      oldDelegate.routeTo != routeTo ||
      oldDelegate.showLabels != showLabels;
}
