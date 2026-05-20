import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/characters_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickYourMagicalFriendView extends StatelessWidget {
  const PickYourMagicalFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              child: BlocBuilder<AuthBloc, AuthStates>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      HeadingText(
                        text: "Pick your\nMagical friend",
                        fontSize: 28,
                        color: AppColors.textYellow,
                        textAlign: TextAlign.center,
                        lineSpacing: 0,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text:
                            "Pick a magical friend to begin your\njourney through the kingdom",
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 1,),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return CharactersRowWidget(
                            characters: state.characters,
                            selectedIdx: state.selectedCharacterIndex,
                            availableWidth: constraints.maxWidth,
                            onSelect: (index) {
                              context.read<AuthBloc>().add(SelectCharacterEvent(index));
                            },
                          );
                        },
                      ),
                      Spacer(),
                      CommonButton(
                        title: 'Continue journey',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.createYourChildProfile,
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
