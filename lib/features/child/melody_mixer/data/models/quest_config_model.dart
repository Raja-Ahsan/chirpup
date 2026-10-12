import 'package:chirp_up_app/features/child/melody_mixer/data/models/quiz_instrument_model.dart';

class QuestConfig {
  final String id;                  // 'quest_dragon_happy'
  final String characterName;       // 'Baby Dragon'
  final String questIntroBackground;
  final String resultTitle;
  final String questResultBackground;   // 👈 add
  final String backgroundAsset;
  final String targetMoodId;        // 'happy'
  final String energyLabel;         // 'JOY ENERGY'
  final List<QuestInstrument> instruments;   // 👈 tray + fix position + isMain
  final int maxInstruments;         // 3

  const QuestConfig({
    required this.id,
    required this.characterName,
    required this.questIntroBackground,
    required this.resultTitle,
    required this.questResultBackground,
    required this.backgroundAsset,
    required this.targetMoodId,
    required this.energyLabel,
    required this.instruments,
    this.maxInstruments = 3,
  });
}