import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quest_config_model.dart';
import 'package:flutter/material.dart';

class MelodyQuestIntroView extends StatelessWidget {
  final QuestConfig quest;
  final VoidCallback continueQuiz;
  final VoidCallback? onBack;

  const MelodyQuestIntroView({
    super.key,
    required this.quest,
    required this.continueQuiz,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) onBack?.call();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // poora quest intro (badge + text + dragon + path) — ek image
            Image.asset(quest.questIntroBackground, fit: BoxFit.fill),

            // button — bottom
            Positioned(
              left: 15,
              right: 15,
              bottom: bottomInset + 5,
              child: SafeArea(
                child: CommonButton(
                  title: 'Continue',
                  onPressed: continueQuiz,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}