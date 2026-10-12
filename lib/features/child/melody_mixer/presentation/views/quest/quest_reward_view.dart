import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/glow_lottie.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quest_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/quest/melody_quest_room_view.dart';
import 'package:flutter/material.dart';

class MelodyQuestRewardView extends StatelessWidget {
  final QuestConfig quest;
  final String backgroundAsset;
  final String dragonLottieAsset;
  final int stars;
  final int coins;
  final double energy;
  final String songDuration;
  final VoidCallback onSaveToPlaylist;
  final VoidCallback onReturnToMusicHall;

  const MelodyQuestRewardView({
    super.key,
    required this.quest,
    required this.backgroundAsset,
    required this.dragonLottieAsset,
    required this.stars,
    required this.coins,
    required this.energy,
    required this.songDuration,
    required this.onSaveToPlaylist,
    required this.onReturnToMusicHall,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) onReturnToMusicHall();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(backgroundAsset, fit: BoxFit.cover),

            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 8),

                  // 2. Stars + coins pill — top center
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
                            SizedBox(height: 5),
                            HeadingText(
                              text: '$stars',
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
                            SizedBox(height: 5),
                            HeadingText(
                              text: '$coins',
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

                  // 3. Result title
                  HeadingText(
                    text: quest.resultTitle,
                    fontSize: 28,
                    color: AppColors.textYellow,
                    shadowColor: Colors.black,
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),

                  const SizedBox(height: 14),

                  // 4. Energy label + bar
                  HeadingText(
                    text: quest.energyLabel,
                    fontSize: 14,
                    fontFamily: 'LuckiestGuy',
                    color: Colors.white,
                    shadowColor: Colors.transparent,
                  ),
                  const SizedBox(height: 6),
                  HorizontalLevelBar(percent: energy),

                  // 5. Glowing lottie + glowing lottie (bada)
                 dragonLottieAsset =='assets/lotties/dragon_winning_lottie.json' ? SizedBox() :  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/gifs/star_animation.gif',
                                width: size.width * 0.75,
                                fit: BoxFit.contain,
                              ),
                              Transform.scale(
                                scale: 1.45,
                                child: GlowLottie(
                                  assetPath:
                                      dragonLottieAsset,
                                  size: size.width * 1.0,
                                ),
                              ),
                            ],
                          ),
                         dragonLottieAsset =='assets/lotties/dragon_winning_lottie.json' ? SizedBox() : SongContainer(duration: '00:10', progress: 0.4),
                        ],
                      ),
                    ),
                  ),

                dragonLottieAsset =='assets/lotties/dragon_winning_lottie.json' ?  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/gifs/star_animation.gif',
                          width: size.width * 0.75,
                          fit: BoxFit.contain,
                        ),
                        Transform.scale(
                          scale: 1.75,
                          child: GlowLottie(
                            assetPath:
                                'assets/lotties/dragon_winning_lottie.json',
                            size: size.width * 1.0,
                          ),
                        ),
                      ],
                    ),
                  ): SizedBox(),

                  dragonLottieAsset =='assets/lotties/dragon_winning_lottie.json' ?SongContainer(duration: '00:10', progress: 0.4):SizedBox(),

                  const SizedBox(height: 14),

                  // 7. Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonButton(
                      title: 'Save to Playlist',
                      bgColor: AppColors.purple,
                      shadowColor: AppColors.textShadowPurple,
                      onPressed: onSaveToPlaylist,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonButton(
                      title: 'return to music hall',
                      bgColor: AppColors.greenColor,
                      onPressed: onReturnToMusicHall,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongContainer extends StatelessWidget {
  final String duration;
  final double progress;
  const SongContainer({required this.duration, this.progress = 0.15});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EDEC),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/png/melody_mixer/ui/play_button.png',
              width: 53,
              height: 53,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFCCC8D0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF645973)),
                  ),
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: duration,
                  fontSize: 16,
                  fontFamily: 'LuckiestGuy',
                  weight: FontWeight.w400,
                  color: const Color(0xFF645973),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
