import 'dart:math' as math;
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class BreathOfKingdomGameView extends StatefulWidget {
  const BreathOfKingdomGameView({super.key});

  @override
  State<BreathOfKingdomGameView> createState() =>
      _BreathOfKingdomGameViewState();
}

class _BreathOfKingdomGameViewState extends State<BreathOfKingdomGameView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _circle1Scale;
  late Animation<double> _circle1Opacity;

  late Animation<double> _circle2Scale;
  late Animation<double> _circle2Opacity;

  late Animation<double> _cloudScale;
  late Animation<double> _cloudOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background ──
            Image.asset(
              'assets/png/breath_of_kingdom_game_bg.png',
              fit: BoxFit.cover,
            ),

            // ── Top: Red circle title ──
            Positioned(
              top: screenHeight * 0.06,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 176,
                      height: 176,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 163,
                      height: 163,
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          progress: 0.5,
                          ringColor: const Color(0xffF9C846),
                          ringWidth: screenWidth * 0.025,
                        ),
                      ),
                    ),
                    Container(
                      width: 153,
                      height: 153,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffE56B58),
                      ),
                      child: Center(
                        child: HeadingText(
                          text: "FILL THE\nDRAGON'S\nHEART\nWITH CALM\nMAGIC",
                          fontSize: 18,
                          textAlign: TextAlign.center,
                          lineSpacing: 0,
                          color: Colors.white,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Character + Cloud + Dots ──
            Positioned(
              bottom: screenHeight * 0.01,
              left: 0,
              right: 0,
              top: screenHeight * 0.35,
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
                      // ── Dragon Character ──
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.breathOfKingdomGameComplete);
                          },
                          child: Image.asset(
                            "assets/png/baby_dragon_character.png",
                            height: characterHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // ── Circle 1 (small dot) ──
                      Positioned(
                        bottom: characterHeight * 0.82,
                        left: stackWidth * 0.5,
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

                      // ── Circle 2 (medium dot) ──
                      Positioned(
                        bottom: characterHeight * 0.89,
                        left: stackWidth * 0.51,
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
                        bottom: characterHeight * 0.89,
                        left: stackWidth * 0.54,
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
                                    left: stackWidth * 0.04,
                                    right: stackWidth * 0.02,
                                    child: CustomText(
                                      text:
                                          "LET'S TAKE SLOW\nMAGICAL BREATHS\nTOGETHER",
                                      color: const Color(0xff645973),
                                      fontSize: stackWidth * 0.034,
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

            // ── Bottom text ──
            Positioned(
              bottom: screenHeight * 0.02,
              left: 0,
              right: 0,
              child: HeadingText(
                text: 'TAP ON DRAGON TO INHALE',
                fontSize: 16,
                fontFamily: 'LuckiestGuy',
                textAlign: TextAlign.center,
                lineSpacing: 0,
                color: Colors.white,
                shadowColor: Colors.transparent,
              ),
            ),

            // ── Back button ──
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                  vertical: AppSizes.verticalPadding,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/png/back_button.png',
                      width: 45,
                      height: 46,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final double ringWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.ringColor,
    required this.ringWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (ringWidth / 2);
    final bgPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) => old.progress != progress;
}
