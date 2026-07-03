import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_bloc.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_events.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_states.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/children_row_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/journey_card_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/level_bar_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/mood_day_widget.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/widgets/parent_dashboard_loading_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentDashboardView extends StatefulWidget {
  const ParentDashboardView({super.key});

  @override
  State<ParentDashboardView> createState() => _ParentDashboardViewState();
}

class _ParentDashboardViewState extends State<ParentDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<ParentDashboardBloc>().add(const FetchChildrenEvent());
  }

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
                _WeeklyJourneySection(state: state),
                const SizedBox(height: 16),
                _MoodSection(state: state),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: Image.asset('assets/png/dashboard_quote_banner.png'),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: CommonButton(
                    title: 'Switch to child Mode',
                    borderColor: const Color(0xff5A7923),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.childProfileSelection,
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

// ── Top Section ───────────────────────────────────────────────────────────────
class _TopSection extends StatelessWidget {
  final ParentDashboardStates state;
  final Child? selected;

  const _TopSection({required this.state, required this.selected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double levelBarWidth = 40.0;
    final double horizontalPadding = AppSizes.horizontalPadding;
    final double childrenRowWidth =
        screenWidth - (horizontalPadding * 2) - levelBarWidth;

    // progressPercent string to double
    final double progressValue =
        (double.tryParse(selected?.progressPercent ?? '0') ?? 0.0) / 100;

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
                        child: state.isLoading
                            ? const TopSectionShimmer()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: levelBarWidth / 2,
                                    ),
                                    child: ChildrenRow(
                                      children: state.children,
                                      selectedIdx: state.selectedChildIndex,
                                      availableWidth: childrenRowWidth,
                                      onSelect: (index) {
                                        final childId =
                                            state.children[index].id;
                                        context.read<ParentDashboardBloc>().add(
                                          SelectChildEvent(
                                            index,
                                            childId ?? '',
                                          ),
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
                                        text: selected!.name!.toUpperCase(),
                                        fontSize: 28,
                                        color: AppColors.textYellow,
                                        textAlign: TextAlign.center,
                                        shadowColor:
                                            AppColors.textShadowDarkBlue,
                                        lineSpacing: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: levelBarWidth / 1,
                                      ),
                                      child: CustomText(
                                        text: selected!.age!.toUpperCase(),
                                        fontSize: 14,
                                        fontFamily: 'LuckiestGuy',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                      if (!state.isLoading)
                        SizedBox(
                          width: levelBarWidth,
                          child: LevelBar(
                            percent: progressValue.clamp(0.0, 1.0),
                            level: selected?.level ?? 1,
                          ),
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

// ── Weekly Journey Section ────────────────────────────────────────────────────
class _WeeklyJourneySection extends StatelessWidget {
  final ParentDashboardStates state;
  const _WeeklyJourneySection({required this.state});

  @override
  Widget build(BuildContext context) {
    final journey = state.weeklyStats?.weeklyJourney;

    final items = [
      JourneyItem(
        label: 'Breathing',
        count: (journey?.breathing ?? 0).toInt(),
        imagePath: 'assets/png/dashboard_dragon.png',
        bgColor: const Color(0xffD6E4F1),
        textColor: const Color(0xff3688E8),
        textShadowColor: const Color(0xff2A547B),
      ),
      JourneyItem(
        label: 'Creative',
        count: (journey?.creative ?? 0).toInt(),
        imagePath: 'assets/png/dashboard_paintbox.png',
        bgColor: const Color(0xffEFEAD3),
        textColor: const Color(0xffF9C846),
        textShadowColor: const Color(0xff433717),
      ),
      JourneyItem(
        label: 'Gratitude',
        count: (journey?.gratitude ?? 0).toInt(),
        imagePath: 'assets/png/dashboard_gratitude.png',
        bgColor: const Color(0xffE1ECE2),
        textColor: const Color(0xff7FAB32),
        textShadowColor: const Color(0xff37471C),
      ),
      JourneyItem(
        label: 'Music',
        count: (journey?.music ?? 0).toInt(),
        imagePath: 'assets/png/dashboard_music.png',
        bgColor: const Color(0xffDDE2EF),
        textColor: const Color(0xff7B6CF4),
        textShadowColor: const Color(0xffA99EFF),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xffECF3F6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: state.isStatsLoading || state.isLoading
            ? const WeeklyJourneyShimmer()
            : Column(
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
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.9,
                        ),
                    itemBuilder: (context, index) {
                      return JourneyCard(item: items[index]);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Mood Section ──────────────────────────────────────────────────────────────
class _MoodSection extends StatelessWidget {
  final ParentDashboardStates state;
  const _MoodSection({required this.state});

  List<MoodItem> _buildMoodItems() {
    final mood = state.weeklyStats?.moodThisWeek;
    final days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final values = [
      mood?.sun?.toString(),
      mood?.mon?.toString(),
      mood?.tue?.toString(),
      mood?.wed?.toString(),
      mood?.thu?.toString(),
      mood?.fri?.toString(),
      mood?.sat?.toString(),
    ];

    return List.generate(7, (i) {
      final moodStr = values[i];
      return MoodItem(
        day: days[i],
        imagePath: moodImagePath(moodStr),
        moodLabel: moodLabel(moodStr),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodItems = _buildMoodItems();
    final summary = state.weeklyStats?.moodSummary ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('assets/png/dashboard_mood_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        child: state.isStatsLoading || state.isLoading
            ? const MoodSectionShimmer()
            : Column(
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
                    color: const Color(0xffB8D8F1),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: moodItems
                        .map((mood) => MoodDayItem(mood: mood))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  if (summary.isNotEmpty)
                    Center(
                      child: CustomText(
                        text: summary,
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
