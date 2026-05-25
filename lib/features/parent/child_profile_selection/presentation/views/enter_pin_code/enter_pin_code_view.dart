import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_bloc.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class EnterPinCodeView extends StatefulWidget {
  const EnterPinCodeView({super.key});

  @override
  State<EnterPinCodeView> createState() => _EnterPinCodeViewState();
}

class _EnterPinCodeViewState extends State<EnterPinCodeView> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildProfileSelectionBloc, ChildProfileSelectionStates>(
      builder: (context, state) {
        final selected = state.children.isEmpty
            ? null
            : state.children[state.selectedChildIndex];

        return Scaffold(
          body: Stack(
            children: [
              // ── Background ──
              Positioned.fill(
                child: Image.asset(
                  "assets/png/child_selection_bg.png",
                  fit: BoxFit.cover,
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.verticalPadding,
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Character Image ──
                      if (selected != null)
                        Image.asset(
                          selected.imagePath,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),

                      const SizedBox(height: 10),

                      // ── Name ──
                      if (selected != null) ...[
                        HeadingText(
                          text: selected.name.toUpperCase(),
                          fontSize: 32,
                          color: AppColors.textYellow,
                          textAlign: TextAlign.center,
                          shadowColor: AppColors.textShadowDarkBlue,
                          lineSpacing: 1,
                        ),
                        CustomText(
                          text: selected.ageRange.toUpperCase(),
                          fontSize: 14,
                          fontFamily: 'LuckiestGuy',
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const Spacer(flex: 1),
                      // ── PIN Title ──
                      CustomText(
                        text: 'Your 4-Digit\nKingdom Code',
                        fontSize: 24,
                        textAlign: TextAlign.center,
                        fontFamily: 'LuckiestGuy',
                        lineSpacing: 1.1,
                      ),

                      const SizedBox(height: 15),

                      // ── Pinput ──
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
                              color: AppColors.otpFieldDarkBlueBg,
                              border: Border.all(color: Colors.white, width: 2),
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
                              color: AppColors.otpFieldDarkBlueBg,
                              border: Border.all(color: Colors.white, width: 2),
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
                              color: AppColors.otpFieldDarkBlueBg,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onChanged: (value) {},
                          onCompleted: (pin) {},
                        ),
                      ),
                      const Spacer(flex: 1),
                      // ── Button ──
                      CommonButton(
                        title: 'Enter Kingdom',
                        onPressed: () {
                          if (_pinController.text.length < 4) {
                            showCommonDialog(
                              context: context,
                              child: errorDialog(
                                context,
                                "Please enter your full\nmagic code to continue.",
                              ),
                              barrierDismissible: true,
                              rightPadding: 10,
                              topPadding: 10,
                            );
                            return;
                          }
                          Navigator.pushReplacementNamed(context, AppRoutes.moodSelection);
                        },
                        horizontalPadding: 50,
                        bgColor: AppColors.textYellow,
                        shadowColor: Color(0xff6E613E),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtitle ──
                      CustomText(
                        text: 'Every adventure starts with magic',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        color: const Color(0xff80BBF3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
