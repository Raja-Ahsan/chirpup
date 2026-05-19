import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget errorDialog(BuildContext context, String dialogText) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: ()=>Navigator.pop(context), icon: SvgPicture.asset('assets/svg/cross.svg')),
        ],
      ),
      Image.asset('assets/png/warning.png', height: 57),
      SizedBox(height: 10),
      CustomText(
        text: 'ERROR',
        fontSize: 24,
        color: AppColors.dialogHeadingColor,
        fontFamily: 'LuckiestGuy',
      ),
      SizedBox(height: 5),
      CustomText(
        text: dialogText,
        fontSize: 14,
        color: AppColors.dialogGreyTextColor,
        textAlign: TextAlign.center,
        weight: FontWeight.w600,
      ),
    ],
  );
}
