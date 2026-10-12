import 'package:chirp_up_app/core/constants/age_group.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_enums.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';

class MelodyMixerConfig {
  final AgeGroup ageGroup;
  final MixerEntry entry;
  final List<MixerStage> flow;
  final InteractionMode interaction;

  final bool moodSelectionEnabled;
  final bool recordingEnabled;
  final bool persistence;
  final bool questsEnabled;
  final bool reflectionEnabled;

  // Mood-less ages (1-2) ek fixed background use karte hain.
  // Mood-based ages (3-4+) yahan aage `moods`/`rooms` map add karenge.
  final String defaultBackgroundAsset;
  final List<MoodConfig> moods;

  const MelodyMixerConfig({
    required this.ageGroup,
    required this.entry,
    required this.flow,
    required this.interaction,
    required this.defaultBackgroundAsset,
    this.moodSelectionEnabled = false,
    this.recordingEnabled = false,
    this.persistence = false,
    this.questsEnabled = false,
    this.reflectionEnabled = false,
    this.moods = const [], 
  });

  MixerStage get firstStage => flow.first;
}