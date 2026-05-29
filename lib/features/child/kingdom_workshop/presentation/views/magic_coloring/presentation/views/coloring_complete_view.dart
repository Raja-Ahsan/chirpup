import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:flutter/material.dart';

class ColoringCompleteView extends StatefulWidget {
  final String sketchImagePath;

  const ColoringCompleteView({
    super.key,
    this.sketchImagePath = 'assets/png/castle_sketch_1.png',
  });

  @override
  State<ColoringCompleteView> createState() => _ColoringCompleteViewState();
}

class _ColoringCompleteViewState extends State<ColoringCompleteView> {
  int _selectedMoodIndex = -1;

  final _moods = [
    MoodItem(
      label: 'Happy',
      imagePath: 'assets/png/happy_mood.png',
      bgColor: Color(0xffEFEAD4),
      selectedBgColor: Color(0xffF9C846),
    ),
    MoodItem(
      label: 'Calm',
      imagePath: 'assets/png/calm_mood.png',
      bgColor: Color(0xffD6E4F0),
      selectedBgColor: Color(0xff73B1F9),
    ),
    MoodItem(
      label: 'Sleepy',
      imagePath: 'assets/png/sleepy_mood.png',
      bgColor: Color(0xffD5E0F0),
      selectedBgColor: Color(0xff496DCD),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
                vertical: AppSizes.verticalPadding,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/png/star.png',
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          children: [
                            SizedBox(height: 5),
                            HeadingText(
                              text: '1',
                              fontSize: 12,
                              color: AppColors.dialogHeadingColor,
                              shadowColor: Colors.transparent,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          'assets/png/coin.png',
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          children: [
                            SizedBox(height: 5),
                            HeadingText(
                              text: '5',
                              fontSize: 12,
                              color: AppColors.dialogHeadingColor,
                              shadowColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // ── Title ──
                  HeadingText(
                    text: "You Created\nSomething Magical!",
                    fontSize: 28,
                    color: AppColors.textYellow,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // ── Notebook / Canvas ──
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  // Spiral top
                                  Image.asset(
                                    'assets/png/coloring_complete_calendar.png',
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                  // Sketch image
                                  Positioned(
                                    bottom: 0,
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      child: Image.asset(
                                        widget.sketchImagePath,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Mood section ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                HeadingText(
                                  text:
                                      "How Does Your Heart Feel\nAfter Coloring Today?",
                                  fontSize: 18,
                                  color: AppColors.dialogHeadingColor,
                                  shadowColor: Colors.transparent,
                                  textAlign: TextAlign.center,
                                  lineSpacing: 0,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(_moods.length, (
                                    index,
                                  ) {
                                    final mood = _moods[index];
                                    final bool isSelected =
                                        _selectedMoodIndex == index;
                                    return GestureDetector(
                                      onTap: () => setState(
                                        () => _selectedMoodIndex = index,
                                      ),
                                      child: Column(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            width: screenWidth * 0.20,
                                            height: screenWidth * 0.20,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? (mood.selectedBgColor)
                                                  : mood.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                mood.imagePath,
                                                height: screenWidth * 0.13,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          HeadingText(
                                            text: (mood.label).toUpperCase(),
                                            fontSize: 13,
                                            color: AppColors.dialogHeadingColor,
                                            shadowColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ── Buttons ──
                  CommonButton(
                    title: 'Color Again',
                    bgColor: AppColors.blueColor,
                    shadowColor: AppColors.textShadowBlue,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 5),
                  CommonButton(
                    title: 'Return to Kingdom',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.childDashboard, (route)=> false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
