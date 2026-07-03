import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LevelBar extends StatelessWidget {
  final double percent;
  final num level;

  const LevelBar({required this.percent, required this.level});

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQuery.of(context).size.height * 0.3;
    final barWidth = 23.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: 'LEVEL',
          fontSize: 14,
          fontFamily: 'LuckiestGuy',
          textAlign: TextAlign.center,
          lineSpacing: 1,
        ),
        CustomText(
          text: '$level',
          fontSize: 14,
          fontFamily: 'LuckiestGuy',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: barHeight,
          width: barWidth,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Background track
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: Color(0xff2978BF),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                width: barWidth,
                height: barHeight * percent,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.whiteColor),
                ),
              ),
              Positioned(
                bottom: (barHeight * percent) - 45,
                child: CustomText(
                  text: '${(percent * 100).toInt()}\n%',
                  fontSize: 16,
                  lineSpacing: 0,
                  textAlign: TextAlign.center,
                  fontFamily: 'LuckiestGuy',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}