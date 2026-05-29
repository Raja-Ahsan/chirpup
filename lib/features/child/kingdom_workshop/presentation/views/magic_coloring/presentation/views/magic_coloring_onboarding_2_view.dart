import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class MagicColoringOnboarding2View extends StatefulWidget {
  const MagicColoringOnboarding2View({super.key});

  @override
  State<MagicColoringOnboarding2View> createState() =>
      _MagicColoringOnboarding2ViewState();
}

class _MagicColoringOnboarding2ViewState
    extends State<MagicColoringOnboarding2View>
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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBookTap() async {
    if (_controller.isAnimating || _controller.isCompleted) return;
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.chooseSketch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_onboarding_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.verticalPadding,
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  children: [
                    HeadingText(
                      text: "The Magical\nBook Awaits",
                      fontSize: 28,
                      color: AppColors.textYellow,
                      textAlign: TextAlign.center,
                      lineSpacing: 0,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "Open the book to explore new\nmagical adventures",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: _onBookTap,
                              child: Image.asset(
                                'assets/png/magic_coloring_book.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          HeadingText(
                            text:
                                'Every page holds a\nmagical secret for you\nto discover',
                            fontSize: 18,
                            shadowColor: Colors.transparent,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
  }
}
