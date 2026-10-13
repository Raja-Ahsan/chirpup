import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? boxColor;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.withValues(alpha: 0.3),
      highlightColor: highlightColor ?? Colors.grey.withValues(alpha: 0.70),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: boxColor ?? Colors.grey.withValues(alpha: 0.6),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}