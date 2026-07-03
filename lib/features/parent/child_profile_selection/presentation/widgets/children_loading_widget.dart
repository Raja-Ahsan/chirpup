import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChildSelectionShimmer extends StatelessWidget {
  const ChildSelectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/png/character_loading.png',
          color: Colors.blue.withValues(alpha: 0.45),
        ),
        const SizedBox(height: 16),
        // Name shimmer
        _shimmerBox(width: 160, height: 28),
        const SizedBox(height: 8),
        // Age shimmer
        _shimmerBox(width: 90, height: 16),
        const SizedBox(height: 20),
        // Level bar shimmer
        _shimmerBox(width: 150, height: 18, radius: 20),
        const SizedBox(height: 6),
        _shimmerBox(width: 200, height: 12),
        Container(width: double.infinity, color: Colors.transparent),
      ],
    );
  }

  Widget _shimmerBox({
    double? width,
    required double height,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.15),
      highlightColor: Colors.white.withValues(alpha: 0.60),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
