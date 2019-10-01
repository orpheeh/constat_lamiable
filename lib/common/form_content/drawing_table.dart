import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingTable extends CustomPainter {
  List<Point> points;
  bool repaint;

  DrawingTable({@required this.points, @required this.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 4;

    List<List<Point>> polygon = [];
    List<Point> list = [];
    for (Point point in points) {
      if (point == null) {
        polygon.add(list);
        list = [];
      } else {
        list.add(point);
      }
    }

    for (List<Point> p in polygon) {
      canvas.drawPoints(
          PointMode.polygon,
          List.generate(p.length, (index) {
            return Offset(p[index].x, p[index].y);
          }),
          paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Point {
  final double x;
  final double y;

  Point({this.x, this.y});
}
