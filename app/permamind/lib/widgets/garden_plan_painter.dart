import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';

class PlanPainter extends CustomPainter {

  Paint _paint;
  final List<VeggieRow> veggies;

  PlanPainter(this.veggies): _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {

    print("${size.height}");

    // Draw canvas background
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(background, _paint);

    final rec1 = Rect.fromLTWH(2, 2, 410, 296);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(rec1, _paint);

    final rec2 = Rect.fromLTWH(8, 8, 398, 284);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(rec2, _paint);

    final rec3 = Rect.fromLTWH(10, 10, 394, 280);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(rec3, _paint);

    final rec4 = Rect.fromLTWH(11, 11, 392, 278);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(rec4, _paint);

    final rec5 = Rect.fromLTWH(15, 15, 384, 270);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(rec5, _paint);

    final p1 = Offset(15, 50);
    final p2 = Offset(399, 50);
    _paint.color = Colors.black;
    _paint.strokeWidth = 0.5;
    canvas.drawLine(p1, p2, _paint);

    final p3 = Offset(15, 100);
    final p4= Offset(50, 100);
    _paint.color = Colors.red;
    _paint.strokeWidth = 0.5;
    canvas.drawLine(p3, p4, _paint);

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}