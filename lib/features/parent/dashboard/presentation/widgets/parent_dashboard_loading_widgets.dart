import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget _shimmerBox({
  double? width,
  double height = 16,
  double radius = 8,
  Color baseColor = const Color(0xffC8D8E8),
  Color highlightColor = const Color(0xffE8F0F8),
}) {
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// ── TOP SECTION SHIMMER ───────────────────────────────────────────────────────
class TopSectionShimmer extends StatelessWidget {
  const TopSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.asset('assets/png/character_loading.png', color: Colors.blue.withValues(alpha: 0.45)),
              const SizedBox(height: 12),
              // Name shimmer
              Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: 0.15),
                highlightColor: Colors.white.withValues(alpha: 0.60),
                child: Container(
                  width: 160,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Age shimmer
              Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: 0.15),
                highlightColor: Colors.white.withValues(alpha: 0.60),
                child: Container(
                  width: 90,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── WEEKLY JOURNEY SHIMMER ────────────────────────────────────────────────────
class WeeklyJourneyShimmer extends StatelessWidget {
  const WeeklyJourneyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer
        _shimmerBox(width: 180, height: 22, radius: 8),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.9,
          ),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: const Color(0xffCDD8E0),
            highlightColor: const Color(0xffE2EBF0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── MOOD SECTION SHIMMER ──────────────────────────────────────────────────────
class MoodSectionShimmer extends StatelessWidget {
  const MoodSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize =
        (MediaQuery.of(context).size.width -
            (AppSizes.horizontalPadding * 2) -
            32 -
            (6 * 8)) /
        6.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Shimmer.fromColors(
          baseColor: const Color(0xff4A8AC4),
          highlightColor: const Color(0xff6AAAD4),
          child: Container(
            width: 160,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Subtitle
        Shimmer.fromColors(
          baseColor: const Color(0xff4A8AC4),
          highlightColor: const Color(0xff6AAAD4),
          child: Container(
            width: 200,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 7 mood boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (_) => Shimmer.fromColors(
              baseColor: const Color(0xff4A8AC4),
              highlightColor: const Color(0xff6AAAD4),
              child: Column(
                children: [
                  Container(
                    width: iconSize,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 28,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Summary line
        Center(
          child: Shimmer.fromColors(
            baseColor: const Color(0xff4A8AC4),
            highlightColor: const Color(0xff6AAAD4),
            child: Container(
              width: 220,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Shimmer.fromColors(
            baseColor: const Color(0xff4A8AC4),
            highlightColor: const Color(0xff6AAAD4),
            child: Container(
              width: 170,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
