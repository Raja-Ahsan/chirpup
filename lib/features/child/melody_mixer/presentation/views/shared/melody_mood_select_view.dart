import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';
import 'package:flutter/material.dart';

class MelodyMoodSelectView extends StatelessWidget {
  final String backgroundAsset;
  final String? characterId;
  final List<MoodConfig> moods;
  final ValueChanged<MoodConfig> onMoodSelected;
  final VoidCallback? onBack;

  const MelodyMoodSelectView({
    super.key,
    required this.backgroundAsset,
    required this.characterId,
    required this.moods,
    required this.onMoodSelected,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;

    final characterPath = CharacterStaticImageMap.imageForCharacterId(
      characterId ?? '',
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Blue background
          Image.asset(backgroundAsset, fit: BoxFit.cover),

          // 2. Character — top center (sheet ke peeche)
          Positioned(
            top: topInset,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: IgnorePointer(
              child: Image.asset(characterPath, fit: BoxFit.contain),
            ),
          ),

          // 3. Bottom sheet — heading + subtitle + grid
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFECF3F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      HeadingText(
                        text: 'How are you\nfeeling today?',
                        fontSize: 28,
                        color: AppColors.dialogHeadingColor,
                        textAlign: TextAlign.center,
                        shadowColor: Colors.white,
                        lineSpacing: 0,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        text: 'Every feeling is welcome in the kingdom',
                        fontSize: 14,
                        weight: FontWeight.w700,
                        color: const Color(0xff777672),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              // Row 1: Happy, Calm
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _MoodCard(
                                        mood: moods[0],
                                        onTap: () => onMoodSelected(moods[0]),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    if (moods.length > 1)
                                      Expanded(
                                        child: _MoodCard(
                                          mood: moods[1],
                                          onTap: () => onMoodSelected(moods[1]),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Row 2: Sad, Excited
                              Expanded(
                                child: Row(
                                  children: [
                                    if (moods.length > 2)
                                      Expanded(
                                        child: _MoodCard(
                                          mood: moods[2],
                                          onTap: () => onMoodSelected(moods[2]),
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    if (moods.length > 3)
                                      Expanded(
                                        child: _MoodCard(
                                          mood: moods[3],
                                          onTap: () => onMoodSelected(moods[3]),
                                        ),
                                      )
                                    else
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Back button (optional)
          if (onBack != null)
            Positioned(
              top: topInset + 8,
              left: 12,
              child: GestureDetector(
                onTap: onBack,
                child: Image.asset(
                  'assets/png/back_button.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
class _MoodCard extends StatelessWidget {
  final MoodConfig mood;
  final VoidCallback onTap;
  const _MoodCard({required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: mood.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Flexible(child: Image.asset(mood.iconAsset,width: 80)),
            const SizedBox(height: 10),
            HeadingText(
              text: mood.label.toUpperCase(),
              fontSize: 18,
              fontFamily: 'LuckiestGuy',
              color: AppColors.dialogHeadingColor,
              textAlign: TextAlign.center,
              shadowColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}