import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget accountVerifiedDialog() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 10),
      Image.asset('assets/png/email_box_verifed.png'),
      SizedBox(height: 5),
      CustomText(
        text: 'Account Verified',
        fontSize: 14,
        color: AppColors.dialogGreyTextColor,
      ),
      SizedBox(height: 25),
      CustomText(
        text: 'You’re All Set!',
        fontSize: 24,
        color: AppColors.dialogHeadingColor,
        fontFamily: 'LuckiestGuy',
      ),
      CustomText(
        text: 'Let’s create your child’s magical space',
        fontSize: 14,
        color: AppColors.dialogGreyTextColor,
      ),
      const SizedBox(height: 24),
      CommonButton(
        title: 'continue',
        horizontalPadding: 60,
      ),
    ],
  );
}
