import 'package:chirp_up_app/core/constants/age_group.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/hum_card_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_enums.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quest_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quiz_instrument_model.dart';
import 'package:flutter/material.dart';

const age7to8HubCards = [
  HubCard(
    flow: MixerFlowId.createSong,
    title: 'Create Your\nOwn Song',
    iconAsset: 'assets/png/melody_mixer/ui/create_music_button_2.png',
  ),
  HubCard(
    flow: MixerFlowId.quest,
    title: 'Advanced Music Quest',
    iconAsset: 'assets/png/melody_mixer/ui/music_quest_2_button.png',
  ),
  HubCard(
    flow: MixerFlowId.playlist,
    title: 'My Music Library',
    iconAsset: 'assets/png/melody_mixer/ui/playlist_button_2.png',
  ),
];

const dummyBraveQuest = QuestConfig(
  id: 'quest_dragon_happy',
  characterName: 'Baby Dragon',
  resultTitle: 'YOUR MUSIC HELPED\nPRINCE FEEL BRAVE!',
  questIntroBackground: 'assets/png/melody_mixer/backgrounds/quest_intro_bg.png',
  questResultBackground: 'assets/png/melody_mixer/backgrounds/quest_complete_bg.png',
  backgroundAsset: 'assets/png/melody_mixer/backgrounds/quest_room_bg.png',
  targetMoodId: 'happy',
  energyLabel: 'JOY ENERGY',
  maxInstruments: 3,
  instruments: [
  QuestInstrument(
    id: 'drum', isMain: true,
    trayAsset: 'assets/png/melody_mixer/quest/quest_drum.png',
    roomAsset: 'assets/png/melody_mixer/instruments/bass_drum.png',
    left: 0.12, top: 0.63, widthFactor: 0.35,
  ),
  QuestInstrument(
    id: 'trumpet', isMain: true,
    trayAsset: 'assets/png/melody_mixer/quest/quest_trumpet.png',
    roomAsset: 'assets/png/melody_mixer/instruments/trumpet.png',
    left: 0.48, top: 0.62, widthFactor: 0.35,
  ),
  QuestInstrument(
    id: 'xylophone',
    trayAsset: 'assets/png/melody_mixer/quest/quest_chime_bars.png',
    roomAsset: 'assets/png/melody_mixer/instruments/chime_bars.png',
    left: 0.44, top: 0.42, widthFactor: 0.30,
  ),
  QuestInstrument(
    id: 'flute',
    trayAsset: 'assets/png/melody_mixer/quest/quest_flute.png',
    roomAsset: 'assets/png/melody_mixer/instruments/flute.png',
    left: 0.46, top: 0.68, widthFactor: 0.26,
  ),
  QuestInstrument(
    id: 'hand_bells',
    trayAsset: 'assets/png/melody_mixer/quest/quest_hand_bells.png',
    roomAsset: 'assets/png/melody_mixer/instruments/hand_bells.png',
    left: 0.64, top: 0.56, widthFactor: 0.24,
  ),
  QuestInstrument(
    id: 'keyboard',
    trayAsset: 'assets/png/melody_mixer/quest/quest_keyboard.png',
    roomAsset: 'assets/png/melody_mixer/instruments/keyboard.png',
    left: 0.13, top: 0.49, widthFactor: 0.35,
  ),
],
);


// ── Har mood ke instruments (positions/assets tum tweak karna) ──
const _happyInstruments = [
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

// const _calmInstruments = [
//   InstrumentPlacement(
//     id: 'keyboard',
//     assetPath: 'assets/png/melody_mixer/instruments/keyboard.png',
//     left: 0.07, top: 0.53, widthFactor: 0.45,
//   ),
//   InstrumentPlacement(
//     id: 'chime_bars',
//     assetPath: 'assets/png/melody_mixer/instruments/chime_bars.png',
//     right: 0.04, top: 0.41, widthFactor: 0.41,
//   ),
//   InstrumentPlacement(
//     id: 'hand_bells',
//     assetPath: 'assets/png/melody_mixer/instruments/hand_bells.png',
//     left: 0.48, top: 0.66, widthFactor: 0.34,
//   ),
// ];

const _calmInstruments = [
  // already the
  InstrumentPlacement(id: 'keyboard', assetPath: 'assets/png/melody_mixer/instruments/keyboard.png', left: 0.06, top: 0.52, widthFactor: 0.40),
  InstrumentPlacement(id: 'chime_bars', assetPath: 'assets/png/melody_mixer/instruments/chime_bars.png', right: 0.04, top: 0.42, widthFactor: 0.40),
  InstrumentPlacement(id: 'hand_bells', assetPath: 'assets/png/melody_mixer/instruments/hand_bells.png', left: 0.45, top: 0.66, widthFactor: 0.30),
  // 👇 missing — test ke liye add
  InstrumentPlacement(id: 'xylophone', assetPath: 'assets/png/melody_mixer/instruments/xylophone.png', left: 0.10, top: 0.70, widthFactor: 0.40),
  InstrumentPlacement(id: 'trumpet', assetPath: 'assets/png/melody_mixer/instruments/trumpet.png', left: 0.50, top: 0.80, widthFactor: 0.40),
  InstrumentPlacement(id: 'maracas', assetPath: 'assets/png/melody_mixer/instruments/maracas.png', left: 0.02, top: 0.30, widthFactor: 0.30),
  InstrumentPlacement(id: 'violin', assetPath: 'assets/png/melody_mixer/instruments/violin.png', right: 0.02, top: 0.72, widthFactor: 0.30),
  InstrumentPlacement(id: 'flute', assetPath: 'assets/png/melody_mixer/instruments/flute.png', left: 0.30, top: 0.88, widthFactor: 0.30),
  InstrumentPlacement(id: 'bass_drum', assetPath: 'assets/png/melody_mixer/instruments/bass_drum.png', left: 0.30, top: 0.55, widthFactor: 0.30),
];

const _sadInstruments = [
  InstrumentPlacement(
    id: 'keyboard',
    assetPath: 'assets/png/melody_mixer/instruments/keyboard.png',
    left: 0.08, top: 0.55, widthFactor: 0.42,
  ),
  InstrumentPlacement(
    id: 'chime_bars',
    assetPath: 'assets/png/melody_mixer/instruments/chime_bars.png',
    right: 0.06, top: 0.48, widthFactor: 0.40,
  ),
  InstrumentPlacement(
    id: 'hand_bells',
    assetPath: 'assets/png/melody_mixer/instruments/hand_bells.png',
    left: 0.38, top: 0.72, widthFactor: 0.34,
  ),
];

const _excitedInstruments = [
  InstrumentPlacement(
    id: 'maracas',
    assetPath: 'assets/png/melody_mixer/instruments/maracas.png',
    left: 0.02, top: 0.34, widthFactor: 0.36,
  ),
  InstrumentPlacement(
    id: 'xylophone',
    assetPath: 'assets/png/melody_mixer/instruments/xylophone.png',
    left: 0.40, top: 0.52, widthFactor: 0.55,
  ),
  InstrumentPlacement(
    id: 'trumpet',
    assetPath: 'assets/png/melody_mixer/instruments/trumpet.png',
    left: 0.06, top: 0.72, widthFactor: 0.66,
  ),
];

const _age7to8Moods = [
  MoodConfig(
    id: 'happy', label: 'Happy',
    iconAsset: 'assets/png/melody_mixer/ui/happy.png',
    cardBgAsset: 'assets/png/melody_mixer/ui/happy_card.png',
    labelColor: Color(0xFFB8860B),   // golden/brown
    cardColor: Color(0xFFF6EBCB), badgeColor: Color(0xFFF4C64A),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/happy_room.png',
    instruments: _happyInstruments,
  ),
  MoodConfig(
    id: 'magical', label: 'Magical',
    iconAsset: 'assets/png/melody_mixer/ui/magical.png',
    cardBgAsset: 'assets/png/melody_mixer/ui/magical_card.png',
    labelColor: Color(0xFF4E944F),   // green
    cardColor: Color(0xFFD9F0DD), badgeColor: Color(0xFF7FD68A),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/magical_room.png',
    instruments: _happyInstruments,
  ),
  MoodConfig(
    id: 'calm', label: 'Calm',
    iconAsset: 'assets/png/melody_mixer/ui/calm.png',
    cardBgAsset: 'assets/png/melody_mixer/ui/calm_card.png',
    labelColor: Color(0xFF4A7FB5),   // blue
    cardColor: Color(0xFFDDE7F1), badgeColor: Color(0xFF75ADFF),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/calm_room.png',
    instruments: _calmInstruments,
  ),
  MoodConfig(
    id: 'brave', label: 'Brave',
    iconAsset: 'assets/png/melody_mixer/ui/brave.png',
    cardBgAsset: 'assets/png/melody_mixer/ui/brave_card.png',
    labelColor: Color(0xFFD9684A),   // red/orange
    cardColor: Color(0xFFF6DEDA), badgeColor: Color(0xFFE88A6F),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/brave_room.png',
    instruments: _excitedInstruments,
  ),
  MoodConfig(
    id: 'dreamy', label: 'Dreamy',
    iconAsset: 'assets/png/melody_mixer/ui/dreamy.png',
    cardBgAsset: 'assets/png/melody_mixer/ui/dreamy_card.png',
    labelColor: Color(0xFF8E7CC3),   // purple
    cardColor: Color(0xFFE8E3F2), badgeColor: Color(0xFFB7A8E0),
    roomBackgroundAsset: 'assets/png/melody_mixer/backgrounds/dreamy_room.png',
    instruments: _calmInstruments,
  ),
];

// ── Config (7-8) ──
const age7to8Config = MelodyMixerConfig(
  ageGroup: AgeGroup.age7to8,
  entry: MixerEntry.hub,
  flow: [
    MixerStage.hub,
    MixerStage.moodSelect,
    MixerStage.play,
    MixerStage.review,
    MixerStage.celebration,
  ],
  interaction: InteractionMode.freePlay,
  moodSelectionEnabled: true,
  recordingEnabled: true,
  persistence: true,
  questsEnabled: true,
  reflectionEnabled: false,
  defaultBackgroundAsset: 'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
  moods: _age7to8Moods, 
);