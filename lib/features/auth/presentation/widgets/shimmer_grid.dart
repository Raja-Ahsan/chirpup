import 'package:chirp_up_app/features/child/child_dashboard/presentation/widgets/shimmer_box_widget.dart';
import 'package:flutter/material.dart';

Widget buildShimmerGrid() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          ShimmerBox(
            height: 51,
            width: 131,
            borderRadius: BorderRadius.circular(16),
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 12),
          ShimmerBox(
            height: 51,
            width: 131,
            borderRadius: BorderRadius.circular(16),
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.45),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          ShimmerBox(
            height: 51,
            width: 131,
            borderRadius: BorderRadius.circular(16),
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 12),
          ShimmerBox(
            height: 51,
            width: 131,
            borderRadius: BorderRadius.circular(16),
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.45),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          ShimmerBox(
            height: 51,
            width: 131,
            borderRadius: BorderRadius.circular(16),
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 12),
          const Expanded(child: SizedBox()),
        ],
      ),
    ],
  );
}
