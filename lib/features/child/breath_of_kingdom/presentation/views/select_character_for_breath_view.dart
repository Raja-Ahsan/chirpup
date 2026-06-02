import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/characters_row_widget.dart';
import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_bloc.dart';
import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_states.dart';
import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCharacterForBreathView extends StatelessWidget {
  const SelectCharacterForBreathView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BreathOfKingdomBloc, BreathOfKingdomStates>(
        builder: (context, state) {
          return Column(
            children: [
              /// TOP SECTION
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/png/breath_game_select_char_bg.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPadding,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20),
                                  HeadingText(
                                    text: 'BREATH OF THE\nKINGDOM',
                                    fontSize: 28,
                                    color: AppColors.textYellow,
                                    textAlign: TextAlign.center,
                                    lineSpacing: 0,
                                  ),

                                  SizedBox(height: 5),

                                  const CustomText(
                                    text:
                                        'Choose a magical friend to guide\nyour calming breathing adventure',
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 14,
                                    weight: FontWeight.w700,
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.15,
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return CharactersRowWidget(
                                        isFromBreathKingdom: true,
                                        characters: state.characters,
                                        selectedIdx:
                                            state.selectedCharacterIndex,
                                        availableWidth: constraints.maxWidth,
                                        onSelect: (index) {
                                          context
                                              .read<BreathOfKingdomBloc>()
                                              .add(SelectCharacterEvent(index));
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              /// BOTTOM SECTION
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                  vertical: AppSizes.verticalPadding,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const CustomText(
                      text:
                          'Tap a magical buddy to\nbegin your breathing quest',
                      textAlign: TextAlign.center,
                      color: Color(0xff787A7B),
                      fontSize: 14,
                      weight: FontWeight.w700,
                    ),

                    const SizedBox(height: 25),

                    CommonButton(
                      title: 'Start Quest',
                      borderColor: const Color(0xff4E6D19),
                      onPressed: ()=> Navigator.pushReplacementNamed(context, AppRoutes.breathOfKingdomOnboarding),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
