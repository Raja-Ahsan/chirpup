import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MelodyCreateIntroView extends StatelessWidget {
  final String backgroundAsset;
  final String? characterId;
  final VoidCallback onStartCreating;
  final VoidCallback? onBack;

  const MelodyCreateIntroView({
    super.key,
    required this.backgroundAsset,
    required this.characterId,
    required this.onStartCreating,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final characterPath =
        CharacterStaticImageMap.lottieForCharacterId(characterId ?? '');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background
          Image.asset(backgroundAsset, fit: BoxFit.cover),

          // 2. Title
          Positioned(
            top: topInset + size.height * 0.06,
            left: 0,
            right: 0,
            child: HeadingText(
              text: 'Make Your\nOwn Music!',
              fontSize: 28,
              color: AppColors.textYellow,
              shadowColor: Colors.black,
              textAlign: TextAlign.center,
              lineSpacing: 0,
            ),
          ),

          // 3. Character — center (button ke upar)
          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.28,
            bottom: bottomInset + 100,
            child: IgnorePointer(
              child: Center(
                child: Lottie.asset(characterPath, fit: BoxFit.contain),
              ),
            ),
          ),

          // 4. Back button
          if (onBack != null)
            Positioned(
              top: topInset + 8,
              left: 15,
              child: GestureDetector(
                onTap: onBack,
                child: Image.asset(
                  'assets/png/back_button.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ),

          // 5. Start Creating — bottom
          Positioned(
            left: 15,
            right: 15,
            bottom: 10,
            child: SafeArea(
              child: CommonButton(
                title: 'Start Creating',
                onPressed: onStartCreating,
              ),
            ),
          ),
        ],
      ),
    );
  }
}