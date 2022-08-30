import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ClockPainter
class ClockPainter extends CustomPainter {
  final int lineCount;
  final int interval;
  final Color color;

  double fullPaintWidth = 18;
  double halfPaintWidth = 8;

  double minAngle = 0;
  double maxAngle = 360;

  final int maxCount;
  final int currentCount;

  ClockPainter({
    required this.interval,
    required this.lineCount,
    required this.color,
    required this.maxCount,
    required this.currentCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = fullPaintWidth;

    var halfPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = halfPaintWidth;

    final Rect canvasBorderRect = Rect.fromLTRB(0, 0, size.width, size.height);
    final double diameter = math.min(canvasBorderRect.width, canvasBorderRect.height);
    final double radius = diameter / 2;
    final Offset centerOffset = Offset(radius, radius);

    _drawBackground(
      canvas: canvas,
      centerOffset: centerOffset,
      radius: radius,
    );
    _drawHourScaleLine(
      canvas: canvas,
      canvasBorderRect: canvasBorderRect,
    );
    _drawMinuteScaleLine(
      canvas: canvas,
      canvasBorderRect: canvasBorderRect,
    );
    _drawCenterPoint(
      canvas: canvas,
      centerOffset: centerOffset,
      radius: radius / 10,
      canvasBorderRect: canvasBorderRect,
    );
    _drawHourPointer(
      canvas: canvas,
      centerOffset: centerOffset,
      radius: radius,
      canvasBorderRect: canvasBorderRect,
      maxCount: maxCount,
      currentCount: currentCount,
    );

    _drawText(
      canvas: canvas,
      centerOffset: centerOffset,
      radius: radius,
      canvasBorderRect: canvasBorderRect,
    );
  }

  double _toAngleValue(double angle) {
    return math.pi * 2 / 360 * angle;
  }

  void _drawBackground({
    required Canvas canvas,
    required Offset centerOffset,
    required double radius,
  }) {
    var backgroundPaint = Paint();
    backgroundPaint
      ..style = PaintingStyle.fill
      ..color = Colors.black12;

    canvas.drawCircle(centerOffset, radius, backgroundPaint);
  }

  void _drawHourScaleLine({
    required Canvas canvas,
    required Rect canvasBorderRect,
  }) {
    double initAngle = 0;
    int count = 12;
    double singleAngle = 360 / count;

    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    double strokeHalf = linePaint.strokeWidth / 2;
    Rect lineRect = Rect.fromLTRB(
      canvasBorderRect.left + strokeHalf,
      canvasBorderRect.top + strokeHalf,
      canvasBorderRect.right - strokeHalf,
      canvasBorderRect.bottom - strokeHalf,
    );
    for (int i = 0; i < count; i++) {
      double startAngle = initAngle + i * singleAngle;
      canvas.drawArc(
        lineRect,
        _toAngleValue(startAngle.toDouble()),
        _toAngleValue(0.3),
        false,
        linePaint,
      );
    }
  }

  void _drawMinuteScaleLine({
    required Canvas canvas,
    required Rect canvasBorderRect,
  }) {
    double initAngle = 0;
    int count = 60;
    double singleAngle = 360 / count;

    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    double strokeHalf = linePaint.strokeWidth / 2;
    Rect lineRect = Rect.fromLTRB(
      canvasBorderRect.left + strokeHalf,
      canvasBorderRect.top + strokeHalf,
      canvasBorderRect.right - strokeHalf,
      canvasBorderRect.bottom - strokeHalf,
    );
    for (int i = 0; i < count; i++) {
      if (i % 5 == 0) continue;
      double startAngle = initAngle + i * singleAngle;
      canvas.drawArc(
        lineRect,
        _toAngleValue(startAngle.toDouble()),
        _toAngleValue(0.3),
        false,
        linePaint,
      );
    }
  }

  void _drawCenterPoint({
    required Canvas canvas,
    required Offset centerOffset,
    required double radius,
    required Rect canvasBorderRect,
  }) {
    Paint paint = Paint();
    paint.color = Colors.green;
    canvas.drawCircle(centerOffset, radius, paint);
  }

  _drawHourPointer({
    required Canvas canvas,
    required Offset centerOffset,
    required double radius,
    required Rect canvasBorderRect,
    required int maxCount,
    required int currentCount,
  }) {
    final double hourPointerLength = radius / 2;
    final double hourPointerStrokeWidth = hourPointerLength / 10;
    Paint paint = Paint();
    paint
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = hourPointerStrokeWidth;

    double sweep = 360 / maxCount * currentCount;

    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(_toAngleValue(sweep));
    canvas.drawLine(Offset.zero, Offset(0 + hourPointerLength, 0), paint);
    canvas.restore();
  }

  _drawText({
    required Canvas canvas,
    required Offset centerOffset,
    required double radius,
    required Rect canvasBorderRect,
  }) {
    var textPainter = TextPainter(
      text: const TextSpan(
          text: "12",
          style: TextStyle(
            color: Colors.red,
          )),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: canvasBorderRect.width,
    );

    canvas.save();
    canvas.translate(0, 0);
    canvas.rotate(_toAngleValue(0));
    canvas.translate(0, -(radius / 2));
    textPainter.paint(canvas, centerOffset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
