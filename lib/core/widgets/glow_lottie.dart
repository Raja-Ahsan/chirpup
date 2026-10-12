import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlowLottie extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color glowColor;
  final double glowRadius;
  final double glowOpacity;

  const GlowLottie({
    super.key,
    required this.assetPath,
    required this.size,
    this.glowColor = const Color(0xFFBFE3FF),
    this.glowRadius = 25,
    this.glowOpacity = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    // FittedBox ke andar bada intrinsic size do → wo box bhar ke scale karega
    Widget lottie(double intrinsic) => SizedBox(
      width: intrinsic,
      height: intrinsic,
      child: Lottie.asset(assetPath, fit: BoxFit.contain, repeat: true),
    );

    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain, // 👈 box poora bhar dega
        child: SizedBox(
          width: 400, // intrinsic reference (koi bhi bada number)
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // glow
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: glowRadius,
                  sigmaY: glowRadius,
                ),
                child: Opacity(
                  opacity: glowOpacity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(glowColor, BlendMode.srcATop),
                    child: lottie(400),
                  ),
                ),
              ),
              // asli lottie
              lottie(400),
            ],
          ),
        ),
      ),
    );
  }
}
