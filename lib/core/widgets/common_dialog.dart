import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final Widget child;
  final double? rightPadding;
  final double? topPadding;

  const CommonDialog({
    super.key,
    required this.child,
    this.rightPadding,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.dialogColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              24,
              topPadding ?? 24,
              rightPadding ?? 24,
              28,
            ),
            child: child,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
