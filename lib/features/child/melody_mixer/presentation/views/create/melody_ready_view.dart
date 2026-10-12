import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/glow_image.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MelodyReadyView extends StatefulWidget {
  final String backgroundAsset;
  final List<InstrumentPlacement> instruments;
  final String moodLabel;
  final String? moodBadgeAsset;
  final int stars;
  final int coins;
  final VoidCallback onSave;
  final VoidCallback onReturn;

  const MelodyReadyView({
    super.key,
    required this.backgroundAsset,
    required this.instruments,
    required this.moodLabel,
    this.moodBadgeAsset,
    required this.stars,
    required this.coins,
    required this.onSave,
    required this.onReturn,
  });

  @override
  State<MelodyReadyView> createState() => _MelodyReadyViewState();
}

class _MelodyReadyViewState extends State<MelodyReadyView> {
  bool _playing = false;
  bool _saving = false;

  void _onSavePressed() {
    setState(() => _saving = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onSave();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) widget.onReturn();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // 2. Stars + coins pill
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
                            const SizedBox(height: 5),
                            HeadingText(
                              text: widget.stars.toString(),
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
                            const SizedBox(height: 5),
                            HeadingText(
                              text: widget.coins.toString(),
                              fontSize: 12,
                              color: AppColors.dialogHeadingColor,
                              shadowColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Title
                  HeadingText(
                    text: 'Your Melody\nis Ready!',
                    fontSize: 28,
                    color: AppColors.textYellow,
                    shadowColor: Colors.black,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),

                  const SizedBox(height: 15),

                  // 5. Instruments — ek center gif (peeche) + triangle layout
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 1,
                        ),
                        child: Column(
                          children: [
                            // 4. Mood badge
                            if (widget.moodBadgeAsset != null)
                              Image.asset(widget.moodBadgeAsset!, height: 73),
                            const SizedBox(height: 4),
                            HeadingText(
                              text: '${widget.moodLabel}\nMelody'.toUpperCase(),
                              fontSize: 14,
                              color: Colors.white,
                              shadowColor: Colors.black,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),
                             SizedBox(height: size.height*0.1),
                            Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                if (_playing)
                                  Transform.translate(
                                    offset: Offset(0, -size.height * 0.2),
                                    child: Image.asset(
                                      'assets/gifs/music_animation.gif',
                                      width: size.width * 0.7,
                                    ),
                                  ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.instruments.isNotEmpty)
                                      _InstrumentItem(
                                        asset: widget.instruments[0].assetPath,
                                        glowing: _playing,
                                        width: size.width * 0.3,
                                      ),
                                    const SizedBox(height: 12),
                                    Transform.translate(
                                      offset: Offset(0, -size.width * 0.06),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: widget.instruments
                                            .skip(1)
                                            .map((p) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                    ),
                                                child: _InstrumentItem(
                                                  asset: p.assetPath,
                                                  glowing: _playing,
                                                  width: size.width * 0.3,
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _playing = !_playing),
                                      child: Image.asset(
                                        _playing
                                            ? 'assets/png/melody_mixer/ui/pause_button.png'
                                            : 'assets/png/melody_mixer/ui/play_button.png',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // 6. Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonButton(
                      title: 'Save Melody',
                      bgColor: AppColors.purple,
                      shadowColor: AppColors.textShadowPurple,
                      onPressed: _onSavePressed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonButton(
                      title: 'Return to Music Hall',
                      bgColor: AppColors.greenColor,
                      onPressed: widget.onReturn,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            if (_saving)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.75),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lotties/music_saved_lottie.json',
                      width: size.width * 1,
                      repeat: false,
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

class _InstrumentItem extends StatelessWidget {
  final String asset;
  final bool glowing;
  final double width;
  const _InstrumentItem({
    required this.asset,
    required this.glowing,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return glowing
        ? GlowImage(assetPath: asset, width: width)
        : Image.asset(asset, width: width);
  }
}
