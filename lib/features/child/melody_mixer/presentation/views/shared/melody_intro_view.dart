import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MelodyIntroView extends StatefulWidget {
  final String backgroundAsset;
  final String? characterId;
  final VoidCallback onTapAnywhere;
  final VoidCallback onReturnToKingdom;
  final VoidCallback? onBack;

  const MelodyIntroView({
    super.key,
    required this.backgroundAsset,
    required this.characterId,
    required this.onTapAnywhere,
    required this.onReturnToKingdom,
    this.onBack,
  });

  @override
  State<MelodyIntroView> createState() => _MelodyIntroViewState();
}

class _MelodyIntroViewState extends State<MelodyIntroView>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _circle1Scale;
  late Animation<double> _circle1Opacity;
  late Animation<double> _circle2Scale;
  late Animation<double> _circle2Opacity;
  late Animation<double> _cloudScale;
  late Animation<double> _cloudOpacity;

  // ── white fade ──
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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

    // white fade controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // white flash → action → wapas saaf
  Future<void> _fadeThen(VoidCallback action) async {
    await _fadeController.forward();
    action();
    if (mounted) _fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final characterPath = CharacterStaticImageMap.lottieForCharacterId(
      widget.characterId ?? '',
    );

    final bubblePos = _BubblePlacement.forCharacter(widget.characterId);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _fadeThen(widget.onTapAnywhere), // 👈 white flash phir play
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            // 2. Character
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset + 100,
              top: size.height * 0.30,
              child: IgnorePointer(
                child: Center(child: Lottie.asset(characterPath)),
              ),
            ),

            // 3. Bubble cluster
            IgnorePointer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  final c1 = w * 0.05;
                  final c2 = w * 0.08;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: h * bubblePos.circle1Top,
                        right: w * bubblePos.circle1Right,
                        child: AnimatedBuilder(
                          animation: _circle1Scale,
                          builder: (_, __) => Opacity(
                            opacity: _circle1Opacity.value,
                            child: Transform.scale(
                              scale: _circle1Scale.value,
                              child: _bubbleDot(c1),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: h * bubblePos.circle2Top,
                        right: w * bubblePos.circle2Right,
                        child: AnimatedBuilder(
                          animation: _circle2Scale,
                          builder: (_, __) => Opacity(
                            opacity: _circle2Opacity.value,
                            child: Transform.scale(
                              scale: _circle2Scale.value,
                              child: _bubbleDot(c2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: h * bubblePos.cloudTop,
                        right: w * 0.02,
                        child: AnimatedBuilder(
                          animation: _cloudScale,
                          builder: (_, __) => Opacity(
                            opacity: _cloudOpacity.value,
                            child: Transform.scale(
                              scale: _cloudScale.value,
                              alignment: Alignment.topRight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/png/cloud_message.png',
                                    width: w * 0.40,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: w * 0.02),
                                    child: CustomText(
                                      text: 'Tap\nanywhere to\nplay',
                                      color: AppColors.textShadowBlue,
                                      fontSize: w * 0.039,
                                      fontFamily: 'LuckiestGuy',
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.w500,
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

            // 4. Back arrow (3-4 mein)
            if (widget.onBack != null)
              Positioned(
                top: topInset + 8,
                left: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/png/back_button.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ),

            // 5. Return to Kingdom
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomInset + 16,
              child: CommonButton(title: 'Return to Kingdom', onPressed: () => Navigator.pop(context)),
            ),

            // 6. White fade overlay — sabse upar (coloring wala exact pattern)
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
      ),
    );
  }

  Widget _bubbleDot(double s) => Container(
    width: s,
    height: s,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
  );
}

class _BubblePlacement {
  final double cloudTop;
  final double circle1Top;
  final double circle1Right;
  final double circle2Top;
  final double circle2Right;

  const _BubblePlacement({
    required this.cloudTop,
    required this.circle1Top,
    required this.circle1Right,
    required this.circle2Top,
    required this.circle2Right,
  });

  static const _default = _BubblePlacement(
    cloudTop: 0.20,
    circle1Top: 0.36,
    circle1Right: 0.32,
    circle2Top: 0.32,
    circle2Right: 0.24,
  );

  static const _dragon = _BubblePlacement(
    cloudTop: 0.30,
    circle1Top: 0.46,
    circle1Right: 0.32,
    circle2Top: 0.42,
    circle2Right: 0.24,
  );

  static _BubblePlacement forCharacter(String? id) {
    switch (id) {
      case 'char_04':
        return _dragon;
      default:
        return _default;
    }
  }
}