import 'package:flutter/material.dart';

/// CustomPainter para el header de la pantalla de detalle (forma en U en el borde inferior).
class DetailHeaderPainter extends CustomPainter {
  DetailHeaderPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.65);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height * 0.65,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DetailHeaderPainter oldDelegate) =>
      oldDelegate.color != color;
}
