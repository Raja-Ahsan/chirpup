import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class TapOnCastleView extends StatefulWidget {
  const TapOnCastleView({super.key});

  @override
  State<TapOnCastleView> createState() => _TapOnCastleViewState();
}

class _TapOnCastleViewState extends State<TapOnCastleView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sunriseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _sunriseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCastleTap(BuildContext context) async {
    if (_controller.isAnimating || _controller.isCompleted) return;

    await _controller.forward();

    await Future.delayed(const Duration(milliseconds: 100));

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.whoAreYou);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/png/castle_bg.png",
                fit: BoxFit.fill,
                width: screenWidth,
                height: screenHeight,
              ),
            ),

            // ── YELLOW SUNRISE ANIMATION (behind castle) ────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _sunriseAnimation,
                builder: (context, _) {
                  final maxRadius = screenHeight * 0.4;
                  final currentRadius = _sunriseAnimation.value * maxRadius;
                  final opacity = (_sunriseAnimation.value * 0.75).clamp(
                    0.0,
                    0.75,
                  );

                  return SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: CustomPaint(
                      painter: _SunrisePainter(
                        radius: currentRadius,
                        opacity: opacity,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/png/castle.png",
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.verticalPadding,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      HeadingText(
                        text: "Your PIN is Set!",
                        fontSize: 28,
                        color: AppColors.textYellow,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        text:
                            "Your child's profile is now secure and\nready to explore their magical world",
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      CustomText(
                        text: "Tap on Castle\nto Enter",
                        fontSize: 16,
                        fontFamily: 'LuckiestGuy',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Image.asset("assets/png/round_arrow.png", height: 60),
                    ],
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(color: Colors.white),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _onCastleTap(context),
                child: Container(
                  height: screenHeight * 0.55,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunrisePainter extends CustomPainter {
  final double radius;
  final double opacity;
  final double screenWidth;
  final double screenHeight;

  _SunrisePainter({
    required this.radius,
    required this.opacity,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (radius <= 0) return;

    final center = Offset(screenWidth / 2, screenHeight * 0.7);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF9C846).withValues(alpha: opacity),
          const Color(0xFFF9C846).withValues(alpha: opacity),
          const Color(0xFFF9C846).withValues(alpha: opacity * 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_SunrisePainter old) =>
      old.radius != radius || old.opacity != opacity;
}
