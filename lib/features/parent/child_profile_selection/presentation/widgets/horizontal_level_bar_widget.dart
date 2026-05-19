
import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class HorizontalLevelBar extends StatelessWidget {
  final double percent;

  const HorizontalLevelBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double barWidth = screenWidth * 0.65;
    const double barHeight = 28.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: barWidth,
          height: barHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xff288DE3),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                width: barWidth * percent,
                height: barHeight,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.whiteColor, width: 1.5),
                ),
              ),

              Positioned(
                left: (barWidth * percent) / 1.4,
                child: SizedBox(
                  width: 40,
                  child: HeadingText(
                    text: '${(percent * 100).toInt()}%',
                    fontSize: 14,
                    shadowColor: Color(0xff594FAD),
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
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