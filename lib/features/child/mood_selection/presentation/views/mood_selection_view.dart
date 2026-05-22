import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/mood_selection/bloc/mood_selection_bloc.dart';
import 'package:chirp_up_app/features/child/mood_selection/bloc/mood_selection_events.dart';
import 'package:chirp_up_app/features/child/mood_selection/bloc/mood_selection_states.dart';
import 'package:chirp_up_app/features/child/mood_selection/presentation/widgets/adventure_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodSelectionView extends StatefulWidget {
  const MoodSelectionView({super.key});

  @override
  State<MoodSelectionView> createState() => _MoodSelectionViewState();
}

class _MoodSelectionViewState extends State<MoodSelectionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onEnterKingdom(BuildContext context) async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.childDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoodSelectionBloc(),
      child: BlocBuilder<MoodSelectionBloc, MoodSelectionStates>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/png/mood_selection_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPadding,
                          vertical: AppSizes.verticalPadding,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            HeadingText(
                              text: 'How Are You\nFeeling Today?',
                              fontSize: 28,
                              color: AppColors.textYellow,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),
                            CustomText(
                              text: 'Every feeling is welcome in the kingdom',
                              fontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPadding,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Mood Grid ──
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xffECF3F6),
                                    ),
                                    padding: EdgeInsets.all(
                                      AppSizes.horizontalPadding,
                                    ),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.moods.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 14,
                                            mainAxisSpacing: 2,
                                            childAspectRatio: 1.08,
                                          ),
                                      itemBuilder: (context, index) {
                                        final mood = state.moods[index];
                                        final bool isSelected =
                                            state.selectedMoodIndex == index;

                                        return GestureDetector(
                                          onTap: () => context
                                              .read<MoodSelectionBloc>()
                                              .add(SelectMoodEvent(index)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                width: double.infinity,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: mood.bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    mood.imagePath,
                                                    height: 75,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              HeadingText(
                                                text: mood.label.toUpperCase(),
                                                fontSize: 20,
                                                textAlign: TextAlign.center,
                                                color: isSelected
                                                    ? AppColors.purple
                                                    : const Color(0xff645973),
                                                shadowColor: Colors.white,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // ── Magical Adventures ──
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xffECF3F6),
                                    ),
                                    padding: EdgeInsets.all(
                                      AppSizes.horizontalPadding,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        HeadingText(
                                          text: 'Magical Adventures For Today',
                                          fontSize: 20,
                                          color: const Color(0xff645973),
                                          shadowColor: Colors.white,
                                        ),
                                        const SizedBox(height: 10),
                                        AdventureCard(
                                          label: 'Breathing',
                                          imagePath:
                                              'assets/png/dashboard_dragon.png',
                                          bgColor: const Color(0xffD6E4F1),
                                          textColor: const Color(0xff3889E8),
                                          shadowColor: Colors.white,
                                          onTap: () {},
                                        ),
                                        const SizedBox(height: 12),
                                        AdventureCard(
                                          label: 'Creative',
                                          imagePath:
                                              'assets/png/dashboard_paintbox.png',
                                          bgColor: const Color(0xffEFEAD4),
                                          textColor: const Color(0xffFFBA03),
                                          shadowColor: const Color(0xff45391A),
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // ── Button ──
                                  CommonButton(
                                    title: 'Enter Kingdom',
                                    onPressed: () => _onEnterKingdom(context),
                                    bgColor: AppColors.purple,
                                    borderColor: const Color(0xff5B51AE),
                                    shadowColor: const Color(0xff5B51AE),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
