import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KingdonIsReadyView extends StatelessWidget {
  const KingdonIsReadyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/kingdom_ready_bg.png",
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.verticalPadding,
                      right: AppSizes.horizontalPadding,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.addAnotherChild);
                      },
                      child: CustomText(
                        text: 'continue',
                        fontSize: 18,
                        fontFamily: 'LuckiestGuy',
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthStates>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeadingText(
                              text: state.childName,
                              fontSize: 36,
                              color: AppColors.textYellow,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),
                            HeadingText(
                              text: "KINGDOM IS READY",
                              fontSize: 34,
                              color: AppColors.whiteColor,
                              textAlign: TextAlign.center,
                            ),
                            CustomText(
                              text: 'A place where they can explore,\ncreate, and feel safe',
                              fontSize: 16,
                              textAlign: TextAlign.center,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),

                BlocBuilder<AuthBloc, AuthStates>(
                  builder: (context, state) {
                    final imageHeight = state.selectedCharacter.imagePath == 'assets/png/baby_dragon_character.png'? 150.0 : 240.0;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 70),
                        child: Image.asset(
                          height: imageHeight,
                          state.selectedCharacter.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}