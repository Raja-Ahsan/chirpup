import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class SetupYourPinView extends StatefulWidget {
  final bool isConfirmMode;
  const SetupYourPinView({super.key, this.isConfirmMode = false});

  @override
  State<SetupYourPinView> createState() => _SetupYourPinViewState();
}

class _SetupYourPinViewState extends State<SetupYourPinView> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/auth_background_blur.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.verticalPadding,
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  if (!widget.isConfirmMode)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.tapOnCastle);
                        },
                        child: CustomText(
                          text: 'skip',
                          fontSize: 18,
                          fontFamily: 'LuckiestGuy',
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 24),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Column(
                      children: [
                        HeadingText(
                          text: "Set Up Your PIN",
                          fontSize: 28,
                          color: AppColors.textYellow,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text:
                              "Create a PIN to protect your child's\nprofile and settings.",
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(),

                        // ✅ PIN label — mode ke hisaab se
                        CustomText(
                          text: widget.isConfirmMode
                              ? 'Confirm your PIN'
                              : 'Enter your 4-digit PIN',
                          fontSize: 16,
                          weight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // PIN input
                        Center(
                          child: Pinput(
                            length: 4,
                            controller: _pinController,
                            obscureText: true,
                            obscuringCharacter: '*',
                            keyboardType: TextInputType.number,
                            defaultPinTheme: PinTheme(
                              width: 59,
                              height: 69,
                              textStyle: const TextStyle(
                                fontSize: 29,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Nutino',
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.otpFieldBlueBg,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 59,
                              height: 69,
                              textStyle: const TextStyle(
                                fontSize: 29,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Nutino',
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.otpFieldBlueBg,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            submittedPinTheme: PinTheme(
                              width: 59,
                              height: 69,
                              textStyle: const TextStyle(
                                fontSize: 29,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Nutino',
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.otpFieldBlueBg,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onChanged: (value) {},
                            onCompleted: (pin) {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  CommonButton(
                    title: widget.isConfirmMode ? 'confirm' : 'continue',
                    onPressed: () {
                      final pin = _pinController.text;
                      if (widget.isConfirmMode) {
                        context.read<AuthBloc>().add(
                          ConfirmPinEvent(context: context, confirmPin: pin),
                        );
                      } else {
                        context.read<AuthBloc>().add(
                          EnterPinEvent(context: context, pin: pin),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
