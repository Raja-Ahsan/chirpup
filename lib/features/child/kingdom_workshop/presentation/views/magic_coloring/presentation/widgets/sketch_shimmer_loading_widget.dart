import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SketchShimmerLoading extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  final Color? baseColor;
  final Color? highlightColor;
  final Color? decorationColor;

  const SketchShimmerLoading({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.withValues(alpha: 0.3),
      highlightColor: highlightColor ?? Colors.grey.withValues(alpha: 0.7),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: decorationColor ?? Colors.grey.withValues(alpha: 0.6),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}