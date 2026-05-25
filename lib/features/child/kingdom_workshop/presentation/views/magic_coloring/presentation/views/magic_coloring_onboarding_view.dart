import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class MagicColoringOnboardingView extends StatefulWidget {
  const MagicColoringOnboardingView({super.key});

  @override
  State<MagicColoringOnboardingView> createState() =>
      _MagicColoringOnboardingViewState();
}

class _MagicColoringOnboardingViewState
    extends State<MagicColoringOnboardingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Circle 1 (small)
  late Animation<double> _circle1Scale;
  late Animation<double> _circle1Opacity;

  // Circle 2 (medium)
  late Animation<double> _circle2Scale;
  late Animation<double> _circle2Opacity;

  // Cloud
  late Animation<double> _cloudScale;
  late Animation<double> _cloudOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ── Circle 1: 0% → 25% ──
    _circle1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );
    _circle1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // ── Circle 2: 20% → 50% ──
    _circle2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.elasticOut),
      ),
    );
    _circle2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
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

    // Auto start
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
              "assets/png/magic_coloring_bg.png",
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.verticalPadding,
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  HeadingText(
                    text: "Bring Colors to\nthe Kingdom",
                    fontSize: 28,
                    color: AppColors.textYellow,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),

                  const SizedBox(height: 10),

                  // ── Character + Speech Bubble area ──
                  Expanded(
                    child: LayoutBuilder(
                      // ✅ LayoutBuilder wrap karo
                      builder: (context, constraints) {
                        final stackHeight = constraints.maxHeight;
                        final stackWidth = constraints.maxWidth;

                        final double characterHeight = stackHeight * 0.72;
                        final double circle1Size = screenWidth * 0.06;
                        final double circle2Size = screenWidth * 0.1;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // ── Character ──
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                "assets/png/magic_coloring.png",
                                height: characterHeight,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // ── Circle 1 (small) ──
                            Positioned(
                              bottom: characterHeight * 0.8,
                              left: stackWidth * 0.43,
                              child: AnimatedBuilder(
                                animation: _circle1Scale,
                                builder: (context, _) => Opacity(
                                  opacity: _circle1Opacity.value,
                                  child: Transform.scale(
                                    scale: _circle1Scale.value,
                                    child: Container(
                                      width: circle1Size,
                                      height: circle1Size,
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

                            // ── Circle 2 (medium) ──
                            Positioned(
                              bottom: characterHeight * 0.82,
                              left: stackWidth * 0.52,
                              child: AnimatedBuilder(
                                animation: _circle2Scale,
                                builder: (context, _) => Opacity(
                                  opacity: _circle2Opacity.value,
                                  child: Transform.scale(
                                    scale: _circle2Scale.value,
                                    child: Container(
                                      width: circle2Size,
                                      height: circle2Size,
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

                            // ── Cloud ──
                            Positioned(
                              bottom: characterHeight * 0.9,
                              left: stackWidth * 0.42,
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
                                          width: stackWidth * 0.62,
                                        ),
                                        Positioned(
                                          bottom: stackWidth * 0.13,
                                          left: stackWidth * 0.13,
                                          child: SizedBox(
                                            child: CustomText(
                                              text:
                                                  'Every magical\npicture is\nwaiting for your\ncreativity',
                                              color: const Color(0xff3688E8),
                                              fontSize: screenWidth * 0.04,
                                              fontFamily: 'LuckiestGuy',
                                              textAlign: TextAlign.center,
                                              lineSpacing: 0,
                                            ),
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
                  SizedBox(height: 10),
                  // ── Button ──
                  CommonButton(
                    title: 'Start Coloring',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.magicColoringOnboarding2,
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
