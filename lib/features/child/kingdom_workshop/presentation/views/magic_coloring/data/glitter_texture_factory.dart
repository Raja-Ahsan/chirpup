import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GlitterTextureFactory {
  static Future<ui.Image> build({
    int size = 64,
    int speckCount = 350, // 👈 900 se ghatakar 350 — kam density
    int seed = 7,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
    final Random rnd = Random(seed);

    for (int i = 0; i < speckCount; i++) {
      final double x = rnd.nextDouble() * size;
      final double y = rnd.nextDouble() * size;
      final double r = 0.3 + rnd.nextDouble() * 0.8;
      final double opacity = 0.25 + rnd.nextDouble() * 0.35; // 👈 0.5-1.0 se ghatakar 0.25-0.6
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }

    // hero sparkles bhi kam aur halke
    for (int i = 0; i < 12; i++) { // 👈 25 se ghatakar 12
      final double x = rnd.nextDouble() * size;
      final double y = rnd.nextDouble() * size;
      canvas.drawCircle(Offset(x, y), 1.4, Paint()..color = Colors.white.withValues(alpha: 0.7)); // 👈 1.0 se 0.7
    }

    final ui.Picture picture = recorder.endRecording();
    return picture.toImage(size, size);
  }
}