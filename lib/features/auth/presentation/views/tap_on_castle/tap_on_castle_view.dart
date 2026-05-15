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

  void _onCastleTap(BuildContext context) async {
    print('Castle tap');
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
            // Background
            Positioned.fill(
              child: Image.asset(
                "assets/png/castle_bg.png",
                fit: BoxFit.fill,
                width: screenWidth,
                height: screenHeight,
              ),
            ),

            // Castle
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _onCastleTap(context),
                child: Image.asset(
                  "assets/png/castle.png",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              ),
            ),

            // Text content
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
