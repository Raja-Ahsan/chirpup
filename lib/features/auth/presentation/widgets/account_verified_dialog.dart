import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AccountVerifiedDialog extends StatefulWidget {
  const AccountVerifiedDialog({super.key});

  @override
  State<AccountVerifiedDialog> createState() => _AccountVerifiedDialogState();
}

class _AccountVerifiedDialogState extends State<AccountVerifiedDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Image.asset('assets/png/email_box_verified.png', height: 57),
        const SizedBox(height: 5),
        CustomText(
          text: 'Account Verified',
          fontSize: 14,
          color: AppColors.dialogGreyTextColor,
        ),
        const SizedBox(height: 25),
        CustomText(
          text: 'You\'re All Set!',
          fontSize: 24,
          color: AppColors.dialogHeadingColor,
          fontFamily: 'LuckiestGuy',
        ),
        CustomText(
          text: 'Let\'s create your child\'s magical space',
          fontSize: 14,
          color: AppColors.dialogGreyTextColor,
        ),
        const SizedBox(height: 24),
        CommonButton(
          title: 'continue',
          horizontalPadding: 60,
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(AppRoutes.pickYourMagicalFriend);
          },
        ),
        SizedBox(height: 10)
      ],
    );
  }
}

Widget accountVerifiedDialog(BuildContext context) {
  return const AccountVerifiedDialog();
}