

import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AgeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AgeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 51,
        width: 131,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor : Color(0xffF6EDEC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.whiteColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16 - 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.buttonPurple,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'LuckiestGuy',
                    shadows: [
                      // Top-Left
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(-2, -2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Top-Right
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(2, -2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Bottom-Right
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(2, 2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Bottom-Left
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(-2, 2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Left
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(-2, 0),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Right
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(2, 0),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Top
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(0, -2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                      // Bottom
                      Shadow(
                        blurRadius: 0,
                        offset: Offset(0, 2),
                        color: isSelected
                            ? AppColors.textshadowGreen
                            : AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: isSelected ? 8 : 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Transform.rotate(
                  angle: -39.44 * (3.14159265 / 180),
                  child: Container(
                    width: 11,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
