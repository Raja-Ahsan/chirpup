
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color bgColor;

  const MoodChip({
    required this.label,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.15;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Center(
            child: Image.asset(imagePath, height: 37, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          text: label.toUpperCase(),
          fontSize: 13,
          color: Color(0xff645973),
          fontFamily: 'LuckiestGuy',
        ),
      ],
    );
  }
}
