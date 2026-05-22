
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class AdventureCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;
  final VoidCallback onTap;

  const AdventureCard({
    required this.label,
    required this.imagePath,
    required this.bgColor,
    required this.textColor,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 121,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            SizedBox(
              width: 125,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
              ),
            ),
            SizedBox(width: 10),
            // ── Label ──
            Expanded(
              child: HeadingText(
                text: label.toUpperCase(),
                fontSize: 24,
                color: textColor,
                shadowColor: shadowColor,
                textAlign: TextAlign.start,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
