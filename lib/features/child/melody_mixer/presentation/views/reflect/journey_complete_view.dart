import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/reflaction_tag_model.dart';
import 'package:flutter/material.dart';

class MelodyJourneyCompleteView extends StatelessWidget {
  final String backgroundAsset;
  final List<InstrumentPlacement> instruments;
  final String moodLabel;
  final String? moodBadgeAsset;
  final ReflectionTag inspiration;
  final int starsEarned;
  final VoidCallback onReturn;
  final VoidCallback onCreateAnother;

  const MelodyJourneyCompleteView({
    super.key,
    required this.backgroundAsset,
    required this.instruments,
    required this.moodLabel,
    this.moodBadgeAsset,
    required this.inspiration,
    required this.starsEarned,
    required this.onReturn,
    required this.onCreateAnother,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) onReturn();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(backgroundAsset, fit: BoxFit.cover),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // title
                  HeadingText(
                    text: 'Your Musical\nJourney is Complete!',
                    fontSize: 28,
                    color: AppColors.textYellow,
                    shadowColor: Colors.black,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),

                  // middle content vertically center
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // mood badge + label
                            if (moodBadgeAsset != null)
                              Image.asset(moodBadgeAsset!, height: 70),
                            const SizedBox(height: 6),
                            HeadingText(
                              text: '$moodLabel\nMelody'.toUpperCase(),
                              fontSize: 20,
                              color: Colors.white,
                              shadowColor: Colors.black,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),

                            const SizedBox(height: 28),

                            // instruments — row with + signs
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _instrumentsWithPlus(size),
                            ),

                            const SizedBox(height: 28),

                            // inspired by
                            CustomText(
                              text: 'Inspired by:',
                              fontSize: 14,
                              weight: FontWeight.w700,
                              color: const Color(0xff9DBEE4),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/png/melody_mixer/ui/glow_star.png',
                                  height: 26,
                                  width: 32,
                                ),
                                const SizedBox(width: 8),
                                HeadingText(
                                  text: inspiration.label
                                      .replaceAll('\n', ' ')
                                      .toUpperCase(),
                                  fontSize: 18,
                                  color: AppColors.textYellow,
                                  shadowColor: Colors.black,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // saved message
                            HeadingText(
                              text:
                                  'Your melody is now saved in\nyour music journey.',
                              fontSize: 18,
                              color: Colors.white,
                              shadowColor: Colors.transparent,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),

                            const SizedBox(height: 24),

                            // stars earned — spin + scale animation
                            _AnimatedStarReward(starsEarned: starsEarned),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonButton(
                      title: 'Return to Music Hall',
                      bgColor: AppColors.greenColor,
                      onPressed: onReturn,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // instruments ke beech + sign
  List<Widget> _instrumentsWithPlus(Size size) {
    final items = <Widget>[];
    for (var i = 0; i < instruments.length; i++) {
      items.add(
        Image.asset(instruments[i].assetPath, width: size.width * 0.16),
      );
      if (i != instruments.length - 1) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: HeadingText(
              text: '+',
              fontSize: 30,
              color: Colors.white,
              shadowColor: Colors.black,
            ),
          ),
        );
      }
    }
    return items;
  }
}

// star reward — spin (fan jaisa) + scale, text spin complete pe
class _AnimatedStarReward extends StatefulWidget {
  final int starsEarned;
  const _AnimatedStarReward({required this.starsEarned});

  @override
  State<_AnimatedStarReward> createState() => _AnimatedStarRewardState();
}

class _AnimatedStarRewardState extends State<_AnimatedStarReward>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _rotation = Tween<double>(begin: 0.0, end: 6.2832).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _c.forward());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Column(
          children: [
            Transform.rotate(
              angle: _rotation.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/png/melody_mixer/ui/star_2.png',
                      height: 80,
                    ),
                    Positioned(
                      top: 32,
                      child: HeadingText(
                        text: '+${widget.starsEarned}',
                        fontSize: 20,
                        color: const Color(0xFF645973),
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: _textOpacity.value,
              child: HeadingText(
                text: 'Stars Earned',
                fontSize: 16,
                color: Colors.white,
                shadowColor: Colors.transparent,
              ),
            ),
          ],
        );
      },
    );
  }
}
