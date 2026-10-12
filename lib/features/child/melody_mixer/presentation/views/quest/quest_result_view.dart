import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quest_config_model.dart';
import 'package:flutter/material.dart';

class MelodyQuestResultView extends StatelessWidget {
  final QuestConfig quest;
  final String backgroundAsset;
  final VoidCallback onContinue;

  const MelodyQuestResultView({
    super.key,
    required this.quest,
    required this.backgroundAsset,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(backgroundAsset, fit: BoxFit.fill),

            // continue button — bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomInset + 16,
              child: CommonButton(
                title: 'Continue',
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}