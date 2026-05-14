import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/account_verified_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Widget otpDialog(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 10),
      Image.asset('assets/png/email_box.png'),
      SizedBox(height: 15),
      CustomText(
        text: 'CHECK YOUR EMAIL',
        fontSize: 24,
        color: AppColors.dialogHeadingColor,
        fontFamily: 'LuckiestGuy',
      ),
      const SizedBox(height: 5),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: AppColors.dialogGreyTextColor,
            height: 1.4,
            fontFamily: 'Nunito',
          ),
          children: [
            const TextSpan(text: "We've sent a code to "),
            TextSpan(
              text: "yo*@gmail.com",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                color: Color(0xff656565),
                fontFamily: 'Nunito',
              ),
            ),
            const TextSpan(text: " to help keep everything safe."),
          ],
        ),
      ),
      const SizedBox(height: 20),
      CustomText(
        text: 'Enter verification code',
        fontSize: 14,
        color: AppColors.dialogGreyTextColor,
      ),
      const SizedBox(height: 12),
      Center(
        child: Pinput(
          length: 4,
          defaultPinTheme: PinTheme(
            width: 59,
            height: 69,
            textStyle: TextStyle(
              fontSize: 29,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nutino',
            ),
            decoration: BoxDecoration(
              color: AppColors.otpFieldBg,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          focusedPinTheme: PinTheme(
            width: 59,
            height: 69,
            textStyle: TextStyle(
              fontSize: 29,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nutino',
            ),
            decoration: BoxDecoration(
              color: AppColors.otpFieldBg,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          submittedPinTheme: PinTheme(
            width: 59,
            height: 69,
            textStyle: TextStyle(
              fontSize: 29,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nutino',
            ),
            decoration: BoxDecoration(
              color: AppColors.otpFieldBg,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // setState(() {
            //   controller.otp = value;
            //   controller.isOtpValid.value = value.length == 6;
            // });
          },
          onCompleted: (pin) {
            // controller.otp = pin;
            // controller.isOtpValid.value = pin.length == 6;

            // if (pin.length == 6) {
            //   controller.verifyOtp(context);
            // }
          },
        ),
      ),
      const SizedBox(height: 24),
      CommonButton(
        title: 'VERIFY',
        bgColor: AppColors.purple,
        horizontalPadding: 60,
        shadowColor: AppColors.textShadowPurple,
        onPressed: () {
          Navigator.pop(context);
          showCommonDialog(
            context: context,
            child: accountVerifiedDialog(context),
            barrierDismissible: true,
          );
        },
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: "Didn't receive it? ",
            fontSize: 13,
            color: AppColors.dialogGreyTextColor,
          ),
          GestureDetector(
            onTap: () {},
            child: CustomText(
              text: 'Resend code',
              fontSize: 13,
              color: Color(0xff656565),
              weight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    ],
  );
}
