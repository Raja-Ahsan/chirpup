import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget confirmationDialog(
  BuildContext context,
  String dialogText, {
  required VoidCallback onConfirm,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/svg/cross.svg'),
          ),
        ],
      ),
      Image.asset('assets/png/warning.png', height: 57),
      const SizedBox(height: 10),
      CustomText(
        text: 'Are You Sure?',
        fontSize: 24,
        color: AppColors.dialogHeadingColor,
        fontFamily: 'LuckiestGuy',
      ),
      CustomText(
        text: dialogText,
        fontSize: 14,
        color: AppColors.dialogGreyTextColor,
        textAlign: TextAlign.center,
        weight: FontWeight.w600,
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
        child: CommonButton(
          title: 'No',
          onPressed: () => Navigator.pop(context),
          bgColor: Color(0xffC7C7C7),
          shadowColor: Color(0xff787878),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: CommonButton(
          title: 'Yes',
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ),
        ],
      ),
      const SizedBox(height: 20),
    ],
  );
}