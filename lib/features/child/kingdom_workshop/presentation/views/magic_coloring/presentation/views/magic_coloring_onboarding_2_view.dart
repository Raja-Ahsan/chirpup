import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class MagicColoringOnboarding2View extends StatelessWidget {
  const MagicColoringOnboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_onboarding_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.verticalPadding,
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  children: [
                    HeadingText(
                      text: "The Magical\nBook Awaits",
                      fontSize: 28,
                      color: AppColors.textYellow,
                      textAlign: TextAlign.center,
                      lineSpacing: 0,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: "Open the book to explore new\nmagical adventures",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                              'assets/png/magic_coloring_book.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 20),
                          HeadingText(
                            text:
                                'Every page holds a\nmagical secret for you\nto discover',
                            fontSize: 18,
                            shadowColor: Colors.transparent,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
