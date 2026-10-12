import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/hum_card_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MelodyHubView extends StatelessWidget {
  final String backgroundAsset;
  final String? characterId;
  final List<HubCard> cards;
  final String? welcomeName;
  final ValueChanged<HubCard> onCardTap;
  final VoidCallback onPlaylistIconTap;
  final VoidCallback onReturnToKingdom;
  final bool showPlaylistButton;
  final bool showBlackLayout;

  const MelodyHubView({
    super.key,
    required this.backgroundAsset,
    required this.characterId,
    required this.cards,
    required this.onCardTap,
    required this.onPlaylistIconTap,
    required this.onReturnToKingdom,
    this.welcomeName,
    this.showPlaylistButton = false,
    this.showBlackLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final characterPath = CharacterStaticImageMap.lottieForCharacterId(
      characterId ?? '',
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(backgroundAsset, fit: BoxFit.cover),

          // 4. Character — center
          Positioned(
            top: characterPath == 'assets/lotties/dragon_lottie.json'
                ? size.height * 0.35
                : size.height * 0.27,
            left: 0,
            right: 0,
            height: size.height * 0.4,
            child: IgnorePointer(
              child: Lottie.asset(characterPath, fit: BoxFit.contain),
            ),
          ),
          if(showBlackLayout)
          Image.asset(
            'assets/png/melody_mixer/ui/overlay.png',
            fit: BoxFit.cover,
          ),
          if (welcomeName != null)
            Positioned(
              top: topInset + 12,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  HeadingText(
                    text: 'Welcome back,',
                    fontSize: 28,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                  HeadingText(
                    text: welcomeName!,
                    fontSize: 28,
                    fontFamily: 'LuckiestGuy',
                    color: AppColors.textYellow,
                    shadowColor: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          // 3. Playlist icon — upper right
          if (showPlaylistButton)
            Positioned(
              top: topInset + 8,
              right: 15,
              child: GestureDetector(
                onTap: onPlaylistIconTap,
                child: Image.asset(
                  'assets/png/melody_mixer/ui/playlist_button.png',
                  height: 53,
                  width: 53,
                ),
              ),
            ),

          Positioned(
            left: 15,
            right: 15,
            bottom: bottomInset + 1,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: cards
                        .map(
                          (c) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _HubCardTile(
                                card: c,
                                onTap: () => onCardTap(c),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  CommonButton(
                    title: 'Return to Kingdom',
                    onPressed: onReturnToKingdom,
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

class _HubCardTile extends StatelessWidget {
  final HubCard card;
  final VoidCallback onTap;
  const _HubCardTile({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Image.asset(card.iconAsset));
  }
}
