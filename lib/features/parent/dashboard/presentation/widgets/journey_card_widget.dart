
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class JourneyCard extends StatelessWidget {
  final JourneyItem item;

  const JourneyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final imageSize = size.width * 0.18;
    final titleSize = size.width * 0.075;
    final subTitleSize = size.width * 0.03;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.only(right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: imageSize.clamp(60, 85),
            width: imageSize.clamp(60, 85),
            child: Image.asset(item.imagePath, fit: BoxFit.cover),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.01),

                HeadingText(
                  text: '${item.count}',
                  fontSize: titleSize.clamp(24, 32),
                  color: item.textColor,
                  shadowColor: item.textShadowColor,
                ),

                Transform.translate(
                  offset: Offset(0, -size.height * 0.012),
                  child: CustomText(
                    text: item.label,
                    fontSize: subTitleSize.clamp(10, 14),
                    color: const Color(0xff717578),
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JourneyItem {
  final String label;
  final int count;
  final String imagePath;
  final Color bgColor;
  final Color textColor;
  final Color textShadowColor;

  const JourneyItem({
    required this.label,
    required this.count,
    required this.imagePath,
    required this.bgColor,
    required this.textColor,
    required this.textShadowColor,
  });
}