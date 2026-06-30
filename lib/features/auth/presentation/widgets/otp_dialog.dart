import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

Widget otpDialog(BuildContext context, {required String email}) {
  String otp = '';
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Image.asset('assets/png/email_box.png', height: 57),
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
                  text: email,
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
                setState(() => otp = value);
              },
              onCompleted: (pin) {
                setState(() => otp = pin);
              },
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthStates>(
            buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
            builder: (context, state) {
              return CommonButton(
                title: 'VERIFY',
                isLoading: state.isLoading,
                bgColor: AppColors.purple,
                horizontalPadding: 60,
                shadowColor: AppColors.textShadowPurple,
                onPressed: () {
                  context.read<AuthBloc>().add(
                    VerifyOtpEvent(context: context, email: email, otp: otp),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthBloc, AuthStates>(
            buildWhen: (prev, curr) => prev.isResendOTP != curr.isResendOTP,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Didn't receive it? ",
                    fontSize: 13,
                    color: AppColors.dialogGreyTextColor,
                  ),
                  GestureDetector(
                    onTap: state.isResendOTP
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                              ResendOtpEvent(context: context, email: email),
                            );
                          },
                    child: CustomText(
                      text: 'Resend code',
                      fontSize: 13,
                      color: state.isResendOTP? AppColors.dialogGreyTextColor : const Color(0xff656565),
                      weight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10)
        ],
      );
    }
  );
}
