import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/custom_textfield.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/age_range_button_widget.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateYourChildProfileView extends StatelessWidget {
  CreateYourChildProfileView({super.key});

  static const List<String> ageRanges = [
    '1-2 YEARS',
    '3-4 YEARS',
    '5-6 YEARS',
    '7-8 YEARS',
    '9+ YEARS',
  ];

  final TextEditingController childNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: Image.asset(
              "assets/png/create_account_background.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ── TOP: Fixed Header ──
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: HeadingText(
                          text: "CREATE YOUR\nCHILD'S PROFILE",
                          fontSize: 28,
                          color: AppColors.textYellow,
                          textAlign: TextAlign.center,
                          lineSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: CustomText(
                          fontSize: 14,
                          textAlign: TextAlign.center,
                          text: "Let's set up a space made just for your child",
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AuthBloc, AuthStates>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              AvatarWidget(
                                avatar: state.selectedCharacter.avatarImage,
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: CustomText(
                                  fontSize: 20,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'LuckiestGuy',
                                  lineSpacing: 0,
                                  text: state.selectedCharacter.name,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // ── MIDDLE: Scrollable Content ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'enter your child\'s name',
                          controller: childNameController,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            CustomText(
                              fontSize: 16,
                              textAlign: TextAlign.start,
                              weight: FontWeight.w600,
                              text: 'Select Age Range',
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _AgeRangeGrid(ageRanges: ageRanges),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<AuthBloc, AuthStates>(
                  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding,
                        vertical: AppSizes.verticalPadding,
                      ),
                      child: CommonButton(
                        title: 'Continue',
                        isLoading: state.isLoading,
                        bgColor: AppColors.blueColor,
                        shadowColor: AppColors.textShadowBlue,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  CreateYourChildProfileEvent(
                                    childName: childNameController.text,
                                    context: context,
                                  ),
                                );
                              },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  AGE RANGE GRID WIDGET
class _AgeRangeGrid extends StatelessWidget {
  final List<String> ageRanges;
  const _AgeRangeGrid({required this.ageRanges});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) {
        final List<Widget> rows = [];

        for (int i = 0; i < ageRanges.length; i += 2) {
          final bool hasSecond = i + 1 < ageRanges.length;
          rows.add(
            Row(
              children: [
                AgeButton(
                  label: ageRanges[i],
                  isSelected: state.selectedAgeRange == ageRanges[i],
                  onTap: () => context.read<AuthBloc>().add(
                    SelectAgeRangeEvent(ageRanges[i]),
                  ),
                ),
                const SizedBox(width: 12),
                hasSecond
                    ? AgeButton(
                        label: ageRanges[i + 1],
                        isSelected: state.selectedAgeRange == ageRanges[i + 1],
                        onTap: () => context.read<AuthBloc>().add(
                          SelectAgeRangeEvent(ageRanges[i + 1]),
                        ),
                      )
                    : const Expanded(child: SizedBox()),
              ],
            ),
          );
          rows.add(const SizedBox(height: 12));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
