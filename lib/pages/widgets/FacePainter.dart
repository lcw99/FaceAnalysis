import 'dart:ui';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  FacePainter({@required this.imageSize, @required this.face});
  final Size imageSize;
  double scaleX, scaleY;
  Face face;
  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    Paint paint;

    if (this.face.headEulerAngleY > 10 || this.face.headEulerAngleY < -10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.green;
    }

    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    FaceContour fc = face.getContour(FaceContourType.face);
    if (fc != null)
      canvas.drawPoints(PointMode.polygon, _scaleOffsets(offsets: fc.positionsList, imageSize: imageSize, widgetSize: size, scaleX: scaleX, scaleY: scaleY), paint);
    FaceLandmark leftEye = face.getLandmark(FaceLandmarkType.leftEye);
    if (leftEye != null)
      canvas.drawCircle(_scaleOffset(offset: leftEye.position, imageSize: imageSize, widgetSize: size, scaleX: scaleX, scaleY: scaleY), 10, paint);

    canvas.drawRRect(
        _scaleRect(
            rect: face.boundingBox,
            imageSize: imageSize,
            widgetSize: size,
            scaleX: scaleX,
            scaleY: scaleY),
        paint);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}

List<Offset> _scaleOffsets(
    {@required List<Offset> offsets,
      @required Size imageSize,
      @required Size widgetSize,
      double scaleX,
      double scaleY}) {
  List<Offset> newOffsets = [];
  for (Offset o in offsets)
    newOffsets.add(_scaleOffset(offset: o, imageSize: imageSize, widgetSize: widgetSize, scaleX: scaleX, scaleY: scaleY));
  return newOffsets;
}

Offset _scaleOffset(
    {@required Offset offset,
      @required Size imageSize,
      @required Size widgetSize,
      double scaleX,
      double scaleY}) {
  return Offset(widgetSize.width - offset.dx * scaleX, offset.dy * scaleY);
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
      Radius.circular(10));
}
