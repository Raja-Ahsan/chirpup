import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/presentation/views/child_profile_selection/child_profile_selection_view.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_bloc.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_events.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_states.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/child_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/children_row_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/journey_card_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/level_bar_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/mood_day_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentDashboardView extends StatelessWidget {
  const ParentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ParentDashboardBloc, ParentDashboardStates>(
        builder: (context, state) {
          final selected = state.children.isEmpty
              ? null
              : state.children[state.selectedChildIndex];

          return SingleChildScrollView(
            child: Column(
              children: [
                _TopSection(state: state, selected: selected),
                const SizedBox(height: 16),
                _WeeklyJourneySection(),
                const SizedBox(height: 16),
                const _MoodSection(),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: Image.asset('assets/png/dashboard_quote_banner.png'),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: CommonButton(
                    title: 'Switch to child Mode ',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.childProfileSelection,
                      arguments: ChildSelectionArgs(
                        children: state.children,
                        selectedIndex: state.selectedChildIndex,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  final ParentDashboardStates state;
  final ChildModel? selected;

  const _TopSection({required this.state, required this.selected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double levelBarWidth = 40.0;
    final double horizontalPadding = AppSizes.horizontalPadding;
    final double childrenRowWidth =
        screenWidth - (horizontalPadding * 2) - levelBarWidth;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/png/parent_dashboard_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSizes.verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          CustomText(
                            text: 'Welcome Back',
                            fontSize: 24,
                            fontFamily: 'LuckiestGuy',
                            textAlign: TextAlign.center,
                          ),
                          CustomText(
                            text:
                                "Track your child's progress and\nexplore the kingdom.",
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset('assets/svg/setting.svg'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: childrenRowWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: levelBarWidth / 2),
                              child: ChildrenRow(
                                children: state.children,
                                selectedIdx: state.selectedChildIndex,
                                availableWidth: childrenRowWidth,
                                onSelect: (index) {
                                  context.read<ParentDashboardBloc>().add(
                                    SelectChildEvent(index),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (selected != null) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: levelBarWidth / 1,
                                ),
                                child: HeadingText(
                                  text: selected!.name.toUpperCase(),
                                  fontSize: 28,
                                  color: AppColors.textYellow,
                                  textAlign: TextAlign.center,
                                  shadowColor: AppColors.textShadowDarkBlue,
                                  lineSpacing: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: levelBarWidth / 1,
                                ),
                                child: CustomText(
                                  text: selected!.ageRange.toUpperCase(),
                                  fontSize: 14,
                                  fontFamily: 'LuckiestGuy',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        width: levelBarWidth,
                        child: LevelBar(percent: 0.64, level: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// THIS WEEK'S JOURNEY
class _WeeklyJourneySection extends StatelessWidget {
  const _WeeklyJourneySection();
  static const _items = [
    JourneyItem(
      label: 'Breathing',
      count: 0,
      imagePath: 'assets/png/dashboard_dragon.png',
      bgColor: Color(0xffD6E4F1),
      textColor: Color(0xff3688E8),
      textShadowColor: Color(0xff2A547B),
    ),
    JourneyItem(
      label: 'Creative',
      count: 3,
      imagePath: 'assets/png/dashboard_paintbox.png',
      bgColor: Color(0xffEFEAD3),
      textColor: Color(0xffF9C846),
      textShadowColor: Color(0xff433717),
    ),
    JourneyItem(
      label: 'Gratitude',
      count: 1,
      imagePath: 'assets/png/dashboard_gratitude.png',
      bgColor: Color(0xffE1ECE2),
      textColor: Color(0xff7FAB32),
      textShadowColor: Color(0xff37471C),
    ),
    JourneyItem(
      label: 'Music',
      count: 0,
      imagePath: 'assets/png/dashboard_music.png',
      bgColor: Color(0xffDDE2EF),
      textColor: Color(0xff7B6CF4),
      textShadowColor: Color(0xffA99EFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xffECF3F6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(
              text: "This Week's Journey",
              fontSize: 20,
              weight: FontWeight.w500,
              color: AppColors.dialogHeadingColor,
              shadowColor: AppColors.whiteColor,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.9,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return JourneyCard(item: item);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// MOOD THIS WEEK SECTION
class _MoodSection extends StatelessWidget {
  const _MoodSection();

  static const _moods = [
    MoodItem(day: 'SUN', imagePath: 'assets/png/happy_mood.png'),
    MoodItem(day: 'MON', imagePath: 'assets/png/calm_mood.png'),
    MoodItem(day: 'TUE', imagePath: 'assets/png/sleepy_mood.png'),
    MoodItem(day: 'WED', imagePath: 'assets/png/angry_mood.png'),
    MoodItem(day: 'THU', imagePath: 'assets/png/sad_mood.png'),
    MoodItem(day: 'FRI', imagePath: 'assets/png/happy_mood.png'),
    MoodItem(day: 'SAT', imagePath: 'assets/png/calm_mood.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage('assets/png/dashboard_mood_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Mood This Week',
              fontSize: 20,
              fontFamily: 'LuckiestGuy',
            ),
            CustomText(
              text: 'Emotional moments overview',
              fontSize: 14,
              color: Color(0xffB8D8F1),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((mood) => MoodDayItem(mood: mood)).toList(),
            ),

            const SizedBox(height: 10),
            Center(
              child: CustomText(
                text: 'A balanced emotional week\nwith positive engagement.',
                fontSize: 14,
                lineSpacing: 1.2,
                weight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
