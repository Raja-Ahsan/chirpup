import 'dart:async';
import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MelodyCelebrationView extends StatefulWidget {
  final String backgroundAsset;
  final String podiumAsset;
  final String? confettiLottieAsset;
  final String? characterId;
  final String? headingText;
  final String? headingSubText;
  final VoidCallback onExit;

  const MelodyCelebrationView({
    super.key,
    required this.backgroundAsset,
    required this.podiumAsset,
    required this.characterId,
    required this.headingText,
    required this.headingSubText,
    required this.onExit,
    this.confettiLottieAsset,
  });

  @override
  State<MelodyCelebrationView> createState() => _MelodyCelebrationViewState();
}

class _MelodyCelebrationViewState extends State<MelodyCelebrationView> {
  Timer? _autoExitTimer;

  @override
  void initState() {
    super.initState();
    // 2 second baad automatic navigation
    _autoExitTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) widget.onExit();
    });
  }

  @override
  void dispose() {
    _autoExitTimer?.cancel(); // screen band ho to timer bhi cancel
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;

    final winLottie = CharacterStaticImageMap.winningLottieForCharacterId(
      widget.characterId,
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) widget.onExit();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            // 2. Confetti (optional) — poori screen pe
            if (widget.confettiLottieAsset != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.asset(
                    widget.confettiLottieAsset!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // 3. Title — "YAY! / BEAUTIFUL SOUNDS!"
            Positioned(
              top: topInset + size.height * 0.06,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  HeadingText(
                    text: widget.headingText??'',
                    fontSize: 28,
                    color: AppColors.textYellow,
                    weight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  HeadingText(
                    text: widget.headingSubText??'',
                    fontSize: 28,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),
                ],
              ),
            ),

            // 4. Podium — bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Image.asset(widget.podiumAsset, fit: BoxFit.contain),
              ),
            ),

            Align(
              alignment: const Alignment(0, -0.15),
              child: IgnorePointer(
                child: Image.asset(
                  'assets/gifs/winning_popup.gif',
                  width: size.width * 0.6,
                ),
              ),
            ),

            // 5. Character winning lottie — podium ke upar khada
            Align(
              alignment: const Alignment(0, 1),
              child: IgnorePointer(
                child: Lottie.asset(
                  winLottie,
                  height: size.height * 0.8,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}