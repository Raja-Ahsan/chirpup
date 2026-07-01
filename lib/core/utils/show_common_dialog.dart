import 'package:flutter/material.dart';
import 'package:chirp_up_app/core/widgets/common_dialog.dart';

Future<T?> showCommonDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = false,
  double? horizontalPadding,
  double? verticalPadding,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (_) => CommonDialog(
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      child: child,
    ),
  );
}
