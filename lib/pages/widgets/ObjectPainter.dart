import 'dart:ui';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ObjectPainter extends CustomPainter {
  ObjectPainter({@required this.imageSize, @required this.detectedObjects});
  final Size imageSize;
  double scaleX, scaleY;
  List<DetectedObject> detectedObjects;
  @override
  void paint(Canvas canvas, Size size) {
    if (detectedObjects == null) return;

    Paint paint;

    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    for (DetectedObject o in detectedObjects)
      canvas.drawRRect(
          _scaleRect(
              rect: o.getBoundinBox(),
              imageSize: imageSize,
              widgetSize: size,
              scaleX: scaleX,
              scaleY: scaleY),
          paint);
  }

  @override
  bool shouldRepaint(ObjectPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.detectedObjects != detectedObjects;
  }
}

RRect _scaleRect(
    {@required Rect rect,
      @required Size imageSize,
      @required Size widgetSize,
      double scaleX,
      double scaleY}) {
  return RRect.fromLTRBR(
      (widgetSize.width - rect.left.toDouble() * scaleX),
      rect.top.toDouble() * scaleY,
      widgetSize.width - rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
      Radius.circular(1));
}
