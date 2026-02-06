import 'package:flutter/material.dart';

class FaceOverlayPainter extends CustomPainter {
  final bool faceDetected;
  final bool faceInPosition;

  FaceOverlayPainter({
    required this.faceDetected,
    required this.faceInPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ===== Background gelap =====
    final overlayPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final center = Offset(size.width / 2.2, size.height / 2.2);
    final ovalWidth = size.width * 0.55;
    final ovalHeight = size.height * 0.35;

    final innerOval = Rect.fromCenter(
      center: center,
      width: ovalWidth,
      height: ovalHeight,
    );

    final overlayPath = Path()
      ..addRect(outerRect)
      ..addOval(innerOval)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, overlayPaint);

    // ===== Border Oval =====
    final borderPaint = Paint()
      ..color = faceInPosition
          ? Colors.green
          : faceDetected
          ? Colors.orange
          : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawOval(innerOval, borderPaint);

    // ===== Corner Guide =====
    // final cornerPaint = Paint()
    //   ..color = faceInPosition
    //       ? Colors.green
    //       : faceDetected
    //       ? Colors.orange
    //       : const Color(0xFF11CFFF)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 5
    //   ..strokeCap = StrokeCap.round;

    // const cornerLength = 40.0;

    // // Top Left
    // canvas.drawLine(
    //   Offset(innerOval.left, innerOval.top + cornerLength),
    //   Offset(innerOval.left, innerOval.top),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(innerOval.left, innerOval.top),
    //   Offset(innerOval.left + cornerLength, innerOval.top),
    //   cornerPaint,
    // );

    // // Top Right
    // canvas.drawLine(
    //   Offset(innerOval.right - cornerLength, innerOval.top),
    //   Offset(innerOval.right, innerOval.top),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(innerOval.right, innerOval.top),
    //   Offset(innerOval.right, innerOval.top + cornerLength),
    //   cornerPaint,
    // );

    // // Bottom Left
    // canvas.drawLine(
    //   Offset(innerOval.left, innerOval.bottom - cornerLength),
    //   Offset(innerOval.left, innerOval.bottom),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(innerOval.left, innerOval.bottom),
    //   Offset(innerOval.left + cornerLength, innerOval.bottom),
    //   cornerPaint,
    // );

    // // Bottom Right
    // canvas.drawLine(
    //   Offset(innerOval.right - cornerLength, innerOval.bottom),
    //   Offset(innerOval.right, innerOval.bottom),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(innerOval.right, innerOval.bottom),
    //   Offset(innerOval.right, innerOval.bottom - cornerLength),
    //   cornerPaint,
    // );
  }

  @override
  bool shouldRepaint(covariant FaceOverlayPainter oldDelegate) {
    return oldDelegate.faceDetected != faceDetected ||
        oldDelegate.faceInPosition != faceInPosition;
  }
}
