import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BreathOfKingdomOnboardingView extends StatelessWidget {
  const BreathOfKingdomOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/breath_of_kingdom_onboarding_bg.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
                vertical: AppSizes.verticalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FDFF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Oh no! ',
                                style: TextStyle(
                                  color: Color(0xFFE76F51),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'LuckiestGuy',
                                ),
                              ),
                              TextSpan(
                                text:
                                    "The Baby Dragon is breathing fire because it’s\nupset.",
                                style: TextStyle(
                                  color: Color(0xff645973),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'LuckiestGuy',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const CustomText(
                          text: "Let's help him calm down\nwith our breathing.",
                          textAlign: TextAlign.center,
                          color: Color(0xff838588),
                          fontSize: 14,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CommonButton(title: 'Begin Breathing', onPressed: ()=> Navigator.pushReplacementNamed(context, AppRoutes.breathOfKingdomGame)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
