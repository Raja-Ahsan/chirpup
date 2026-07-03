import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/utils/helper_methods.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_bloc.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_events.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_states.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/presentation/widgets/children_loading_widget.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/presentation/widgets/horizontal_level_bar_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/children_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildProfileSelectionView extends StatefulWidget {
  const ChildProfileSelectionView({super.key});

  @override
  State<ChildProfileSelectionView> createState() =>
      _ChildProfileSelectionViewState();
}

class _ChildProfileSelectionViewState extends State<ChildProfileSelectionView> {
  @override
  void initState() {
    super.initState();
    context.read<ChildProfileSelectionBloc>().add(const FetchChildrenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildProfileSelectionBloc, ChildProfileSelectionStates>(
      builder: (context, state) {
        final selected = state.selectedChild;

        // progress value
        final double progressValue =
            (double.tryParse(selected?.progressPercent ?? '0') ?? 0.0) / 100;

        return Stack(
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    HeadingText(
                      text: "Pick an Explorer",
                      fontSize: 28,
                      color: AppColors.textYellow,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      text:
                          "Choose a child profile to continue\ntheir magical journey",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    if (state.isLoading)
                      const ChildSelectionShimmer()
                    else ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ChildrenRow(
                            children: state.children,
                            selectedIdx: state.selectedChildIndex,
                            availableWidth: constraints.maxWidth,
                            onSelect: (index) {
                              context.read<ChildProfileSelectionBloc>().add(
                                SelectChildProfileEvent(index),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      if (selected != null) ...[
                        CustomText(
                          text: HelperMethods()
                              .characterSpecialityFromCharacterId(
                                selected.characterId,
                              ),
                          fontSize: 14,
                          fontFamily: 'LuckiestGuy',
                          textAlign: TextAlign.center,
                        ),
                        HeadingText(
                          text: (selected.name ?? '').toUpperCase(),
                          fontSize: 28,
                          color: AppColors.textYellow,
                          textAlign: TextAlign.center,
                          shadowColor: AppColors.textShadowDarkBlue,
                          lineSpacing: 1,
                        ),
                        CustomText(
                          text: (selected.age ?? '').toUpperCase(),
                          fontSize: 14,
                          fontFamily: 'LuckiestGuy',
                          textAlign: TextAlign.center,
                        ),
                      ],

                      const SizedBox(height: 20),
                      HorizontalLevelBar(
                        percent: progressValue.clamp(0.0, 1.0),
                      ),
                      const SizedBox(height: 6),
                      CustomText(
                        text: 'Growing through magical moments',
                        fontSize: 12,
                        textAlign: TextAlign.center,
                        color: const Color(0xff80BBF3),
                      ),
                    ],

                    const SizedBox(height: 10),
                    const Spacer(),
                    CommonButton(
                      title: state.isPinLoading
                          ? "       Loading...        "
                          : 'Enter Kingdom',
                      horizontalPadding: 50,
                      onPressed: state.isLoading || state.isPinLoading
                          ? null
                          : () {
                              context.read<ChildProfileSelectionBloc>().add(
                                CheckPinStatusAndNavigateEvent(
                                  context: context,
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
