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
import 'package:chirp_up_app/features/auth/presentation/widgets/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateYourChildProfileView extends StatefulWidget {
  const CreateYourChildProfileView({super.key});

  @override
  State<CreateYourChildProfileView> createState() =>
      _CreateYourChildProfileViewState();
}

class _CreateYourChildProfileViewState
    extends State<CreateYourChildProfileView> {
  final TextEditingController childNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(YearsRequested());
    });
  }

  @override
  void dispose() {
    childNameController.dispose();
    super.dispose();
  }

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
                                avatar: state.selectedCharacter?.avatarImage ?? '',
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: CustomText(
                                  fontSize: 20,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'LuckiestGuy',
                                  lineSpacing: 0,
                                  text: state.selectedCharacter?.name ?? '',
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
                        const _AgeRangeGrid(),
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

//  AGE RANGE GRID WIDGET — ab dynamic hai, static list poori tarah hata di
class _AgeRangeGrid extends StatelessWidget {
  const _AgeRangeGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) {
        if (state.isYearsLoading) {
           return buildShimmerGrid();
        }

        if (state.years.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: CustomText(
                text: 'Could not load age ranges.',
                fontSize: 14,
              ),
            ),
          );
        }

        final years = state.years;
        final List<Widget> rows = [];

        for (int i = 0; i < years.length; i += 2) {
          final bool hasSecond = i + 1 < years.length;
          rows.add(
            Row(
              children: [
                AgeButton(
                  label: years[i].title.toUpperCase(),
                  isSelected: state.selectedYearIndex == i,
                  onTap: () => context.read<AuthBloc>().add(
                    SelectAgeRangeEvent(i.toString()),
                  ),
                ),
                const SizedBox(width: 12),
                hasSecond
                    ? AgeButton(
                        label: years[i + 1].title.toUpperCase(),
                        isSelected: state.selectedYearIndex == i + 1,
                        onTap: () => context.read<AuthBloc>().add(
                          SelectAgeRangeEvent((i + 1).toString()),
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
