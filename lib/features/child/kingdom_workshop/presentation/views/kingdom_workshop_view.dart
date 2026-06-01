import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class KingdomWorkshopView extends StatelessWidget {
  const KingdomWorkshopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _TopSection(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.verticalPadding,
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double itemWidth = (constraints.maxWidth - 10) / 2;
                      final double itemHeight = itemWidth * 1.4;
                  
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.buildCastle,
                                ),
                                child: Image.asset(
                                  'assets/png/castle_builder_bg.png',
                                  width: itemWidth,
                                  height: itemHeight,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.magicColoringOnboarding,
                                ),
                                child: Image.asset(
                                  'assets/png/magic_coloring_bg_game.png',
                                  width: itemWidth,
                                  height: itemHeight,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Image.asset('assets/png/kingdom_workshop_banner_bg.png')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSection extends StatefulWidget {
  @override
  State<_TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<_TopSection>
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
    final screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = AppSizes.horizontalPadding;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      width: double.infinity,
      height: screenHeight * 0.75,
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
                  HeadingText(
                    text: 'Kingdom\nWorkshop',
                    fontSize: 28,
                    fontFamily: 'LuckiestGuy',
                    lineSpacing: 0,
                    textAlign: TextAlign.center,
                    color: AppColors.textYellow,
                  ),
                  CustomText(
                    text: "Let your imagination bring\nthe kingdom to life",
                    fontSize: 14,
                    weight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ── Character + Bubbles ──
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final stackHeight = constraints.maxHeight;
                        final stackWidth = constraints.maxWidth;
                        final double characterHeight = stackHeight * 0.85;
                        final double circle1Size = stackWidth * 0.05;
                        final double circle2Size = stackWidth * 0.09;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // ── Character ──
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                "assets/png/prince_character.png",
                                height: characterHeight,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // ── Circle 1 ──
                            Positioned(
                              bottom: characterHeight * 0.78,
                              left: stackWidth * 0.6,
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

                            // ── Circle 2 ──
                            Positioned(
                              bottom: characterHeight * 0.81,
                              left: stackWidth * 0.66,
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
                              bottom: characterHeight * 0.88,
                              left: stackWidth * 0.58,
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
                                          width: stackWidth * 0.45,
                                        ),
                                        Positioned(
                                          bottom: stackWidth * 0.1,
                                          left: stackWidth * 0.10,
                                          child: CustomText(
                                            text:
                                                'Let\'s create a\npeaceful place\njust for you',
                                            color: const Color(0xff645973),
                                            fontSize: stackWidth * 0.035,
                                            fontFamily: 'LuckiestGuy',
                                            textAlign: TextAlign.center,
                                            lineSpacing: 0,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
