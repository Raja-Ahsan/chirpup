import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final Widget child;

  const CommonDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
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
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
        child: child,
      ),
    );
  }
}
