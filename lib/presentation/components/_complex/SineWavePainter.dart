import 'dart:async';
import 'dart:ui' as ui;
import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:YLift/core/controllers/global.dart';

import 'package:YLift/core/constants/index.dart';

class SineWavePainter extends CustomPainter {
  final double animation;
  final double dotSize;
  final double dotSpacing;
  final double amplitude;
  final Size screenSize;
  final bool useImage;
  final ui.Image? loadedImage;
  final double imageSize;

  SineWavePainter({
    required this.animation,
    required this.dotSize,
    required this.dotSpacing,
    required this.amplitude,
    required this.screenSize,
    required this.useImage,
    this.loadedImage,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (useImage && loadedImage != null) {
      _paintWithImage(canvas, size);
    } else {
      _paintWithDots(canvas, size);
    }
  }

  void _paintWithDots(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final numDots = (size.width + 200 / dotSpacing).ceil();
    final centerY = size.height / 2;

    for (var i = 0; i < numDots; i++) {
      final x = i * dotSpacing;
      final y = centerY + math.sin((x / size.width * 2 * math.pi) + (animation * 2 * math.pi)) * amplitude;

      canvas.drawCircle(
        Offset(x, y),
        dotSize / 2,
        paint,
      );
    }
  }

  void _paintWithImage(Canvas canvas, Size size) {
    if (loadedImage == null) return;

    final numImages = (size.width + 200 / dotSpacing).ceil();
    final centerY = size.height / 2;
    final paint = Paint();

    for (var i = 0; i < numImages; i++) {
      final x = i * dotSpacing;
      final y = centerY + math.sin((x / size.width * 2 * math.pi) + (animation * 2 * math.pi)) * amplitude;

      final srcRect = Rect.fromLTWH(
        0,
        0,
        loadedImage!.width.toDouble(),
        loadedImage!.height.toDouble(),
      );

      final dstRect = Rect.fromCenter(
        center: Offset(x, y),
        width: imageSize,
        height: imageSize,
      );

      canvas.save();
      canvas.translate(x, y);
      if (!useImage) {
        // adds rotation effect
        canvas.rotate(animation * 2 * math.pi);
      }
      canvas.translate(-x, -y);
      canvas.drawImageRect(loadedImage!, srcRect, dstRect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(SineWavePainter oldDelegate) =>
      animation != oldDelegate.animation || useImage != oldDelegate.useImage;
}
