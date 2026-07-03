import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color bgColor;
  final Color selectedBgColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoodChip({
    super.key,
    required this.label,
    required this.imagePath,
    required this.bgColor,
    required this.selectedBgColor,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.15;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isSelected ? selectedBgColor : bgColor,
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
            color: const Color(0xff645973),
            fontFamily: 'LuckiestGuy',
          ),
        ],
      ),
    );
  }
}
