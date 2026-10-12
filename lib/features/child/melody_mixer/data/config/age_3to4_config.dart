import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:flutter/material.dart';
import 'package:chirp_up_app/core/constants/age_group.dart';
import '../models/melody_mixer_config_model.dart';
import '../models/melody_mixer_enums.dart';
import '../models/mood_config_model.dart';

const _instruments = [
  InstrumentPlacement(
    id: 'maracas',
    assetPath: 'assets/png/melody_mixer/instruments/maracas.png',
    left: 0.04, top: 0.4, widthFactor: 0.5,
  ),
  InstrumentPlacement(
    id: 'xylophone',
    assetPath: 'assets/png/melody_mixer/instruments/xylophone_2.png',
    left: 0.35, top: 0.55, widthFactor: 0.58,
  ),
  InstrumentPlacement(
    id: 'trumpet',
    assetPath: 'assets/png/melody_mixer/instruments/trumpet.png',
    left: 0.08, top: 0.7, widthFactor: 0.68,
  ),
];

const _age3to4Moods = [
  MoodConfig(
    id: 'happy',
    label: 'Happy',
    iconAsset: 'assets/png/melody_mixer/ui/happy.png',
    cardColor: Color(0xFFF6EBCB),
    badgeColor: Color(0xFFF9C846),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/happy_room.png',
    instruments: _instruments,
  ),
  MoodConfig(
    id: 'calm',
    label: 'Calm',
    iconAsset: 'assets/png/melody_mixer/ui/calm.png',
    cardColor: Color(0xFFDDE7F1),
    badgeColor: Color(0xFF66A5FF),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/calm_room.png',
    instruments: _instruments,
  ),
  MoodConfig(
    id: 'sad',
    label: 'Sad',
    iconAsset: 'assets/png/melody_mixer/ui/sad.png',
    cardColor: Color(0xFFDEE1E7),
    badgeColor: Color(0xFFC9CFD9),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/sad_room.png',
    instruments: _instruments,
  ),
  MoodConfig(
    id: 'excited',
    label: 'Excited',
    iconAsset: 'assets/png/melody_mixer/ui/excited.png',
    cardColor: Color(0xFFEADFE8),
    badgeColor: Color(0xFFE3C7E0),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/excited_room.png',
    instruments: _instruments,
  ),
];

const age3to4Config = MelodyMixerConfig(
  ageGroup: AgeGroup.age3to4,
  entry: MixerEntry.direct,
  flow: [MixerStage.moodSelect, MixerStage.intro, MixerStage.play, MixerStage.celebration],
  interaction: InteractionMode.freePlay,
  moodSelectionEnabled: true,
  recordingEnabled: false,
  persistence: false,
  questsEnabled: false,
  reflectionEnabled: false,
  defaultBackgroundAsset: 'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
  moods: _age3to4Moods,
);