import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:flutter/material.dart';

class BreathOfKingdomGameCompleteView extends StatefulWidget {
  const BreathOfKingdomGameCompleteView({super.key});

  @override
  State<BreathOfKingdomGameCompleteView> createState() =>
      _BreathOfKingdomGameCompleteViewState();
}

class _BreathOfKingdomGameCompleteViewState
    extends State<BreathOfKingdomGameCompleteView>
    with SingleTickerProviderStateMixin {
  int _selectedMoodIndex = -1;

  // ── Animation controller for cloud + dots ──
  late AnimationController _controller;

  // Dot 1 (small)
  late Animation<double> _dot1Scale;
  late Animation<double> _dot1Opacity;

  // Dot 2 (medium)
  late Animation<double> _dot2Scale;
  late Animation<double> _dot2Opacity;

  // Cloud
  late Animation<double> _cloudScale;
  late Animation<double> _cloudOpacity;

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
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ── Dot 1: 0% → 25% ──
    _dot1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );
    _dot1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // ── Dot 2: 20% → 50% ──
    _dot2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.elasticOut),
      ),
    );
    _dot2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.45, curve: Curves.easeIn),
      ),
    );

    // ── Cloud: 45% → 85% ──
    _cloudScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.elasticOut),
      ),
    );
    _cloudOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );

    // Auto-start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_onboarding_bg.png",
              fit: BoxFit.fill,
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
                  // ── Stars & Coins ──
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
                    text: "Great Breathing!",
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
                          // ── Dragon Character + Cloud Bubble ──
                          Container(
                            margin: EdgeInsets.only(left: 30,right: 30 ,top: 120),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final stackWidth = constraints.maxWidth;
                                // Dot sizes
                                final double dot1Size = stackWidth * 0.05;
                                final double dot2Size = stackWidth * 0.09;

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // ── Dragon image ──
                                    Image.asset(
                                      'assets/png/baby_dragon_character.png',
                                    ),

                                    // ── Dot 1 (small) ──
                                    Positioned(
                                      // Sits just above dragon's head, slightly right of center
                                      top: stackWidth * 0.05,
                                      left: stackWidth * 0.52,
                                      child: AnimatedBuilder(
                                        animation: _dot1Scale,
                                        builder: (context, _) => Opacity(
                                          opacity: _dot1Opacity.value,
                                          child: Transform.scale(
                                            scale: _dot1Scale.value,
                                            child: Container(
                                              width: dot1Size,
                                              height: dot1Size,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ── Dot 2 (medium) ──
                                    Positioned(
                                      top: -stackWidth * 0.07,
                                      left: stackWidth * 0.53,
                                      child: AnimatedBuilder(
                                        animation: _dot2Scale,
                                        builder: (context, _) => Opacity(
                                          opacity: _dot2Opacity.value,
                                          child: Transform.scale(
                                            scale: _dot2Scale.value,
                                            child: Container(
                                              width: dot2Size,
                                              height: dot2Size,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ── Cloud speech bubble ──
                                    Positioned(
                                      top: -stackWidth * 0.35,
                                      left: stackWidth * 0.55,
                                      child: AnimatedBuilder(
                                        animation: _cloudScale,
                                        builder: (context, _) => Opacity(
                                          opacity: _cloudOpacity.value,
                                          child: Transform.scale(
                                            scale: _cloudScale.value,
                                            alignment: Alignment.bottomLeft,
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                  'assets/png/cloud_message.png',
                                                  width: stackWidth * 0.6,
                                                ),
                                                Positioned(
                                                  bottom: stackWidth * 0.14,
                                                  left: stackWidth * 0.08,
                                                  right: stackWidth * 0.05,
                                                  child: HeadingText(
                                                    text:
                                                        'You helped\nthe baby dragon\nfeel calm!',
                                                    color: const Color(
                                                      0xff7FAB32,
                                                    ),
                                                    fontSize: stackWidth * 0.045,
                                                    textAlign: TextAlign.center,
                                                    lineSpacing: 0,
                                                    shadowColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                                  text: "How Does Your Heart\nFeel now?",
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

                  // ── Return Button ──
                  CommonButton(
                    title: 'Return to Kingdom',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.childDashboard,
                      (route) => false,
                    ),
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