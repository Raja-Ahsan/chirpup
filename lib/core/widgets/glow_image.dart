import 'dart:ui';

import 'package:flutter/material.dart';

class GlowImage extends StatelessWidget {
  final String assetPath;
  final double width;
  final double? height;
  final Color glowColor;
  final double glowRadius;
  final double glowOpacity;

  const GlowImage({
    super.key,
    required this.assetPath,
    required this.width,
    this.height,
    this.glowColor = const Color(0xFFFFE9A8),
    this.glowRadius = 40,
    this.glowOpacity = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(assetPath, width: width, height: height,
        fit: BoxFit.contain);

    return Stack(
      alignment: Alignment.center,
      children: [
        // glow = wahi image, blur + tint, peeche
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: glowRadius, sigmaY: glowRadius),
          child: Opacity(
            opacity: glowOpacity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(glowColor, BlendMode.srcATop),
              child: img,
            ),
          ),
        ),
        img,
      ],
    );
  }
}