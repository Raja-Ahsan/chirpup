import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatar;
  const AvatarWidget({required this.avatar, super.key});

  static const Color avatarBgColor = Color(0xFFFCE6A9);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatarBgColor,
          border: Border.all(color: AppColors.whiteColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                avatar,
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 0.99,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    stops: const [0.0, 0.9, 1.0],
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