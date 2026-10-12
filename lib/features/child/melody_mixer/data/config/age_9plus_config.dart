import 'package:chirp_up_app/core/constants/age_group.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/hum_card_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_enums.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/reflaction_tag_model.dart';
import 'package:flutter/material.dart';

const age9plusHubCards = [
  HubCard(
    flow: MixerFlowId.createSong,
    title: 'Create\nMake a new song',
    iconAsset: 'assets/png/melody_mixer/ui/create_music_button_3.png',
  ),
  HubCard(
    flow: MixerFlowId.playlist,
    title: 'My Playlists\nListen to your songs',
    iconAsset: 'assets/png/melody_mixer/ui/playlist_button_3.png',
  ),
  HubCard(
    flow: MixerFlowId.reflect,
    title: 'Reflect\nWrite about your feelings',
    iconAsset: 'assets/png/melody_mixer/ui/reflect_button.png',
  ),
];

const _happyInstruments = [
  InstrumentPlacement(
    id: 'drum',
    assetPath: 'assets/png/melody_mixer/instruments/bass_drum.png',
    left: 0.12, top: 0.63, widthFactor: 0.35,
  ),
  InstrumentPlacement(
    id: 'trumpet',
    assetPath: 'assets/png/melody_mixer/instruments/trumpet.png',
    left: 0.48, top: 0.62, widthFactor: 0.35,
  ),
  InstrumentPlacement(
    id: 'xylophone',
    assetPath: 'assets/png/melody_mixer/instruments/chime_bars.png',
    left: 0.44, top: 0.42, widthFactor: 0.30,
  ),
  InstrumentPlacement(
    id: 'flute',
    assetPath: 'assets/png/melody_mixer/instruments/flute.png',
    left: 0.46, top: 0.68, widthFactor: 0.26,
  ),
  InstrumentPlacement(
    id: 'hand_bells',
    assetPath: 'assets/png/melody_mixer/instruments/hand_bells.png',
    left: 0.64, top: 0.56, widthFactor: 0.24,
  ),
  InstrumentPlacement(
    id: 'keyboard',
    assetPath: 'assets/png/melody_mixer/instruments/keyboard.png',
    left: 0.13, top: 0.49, widthFactor: 0.35,
  ),
];

const _calmInstruments = [
  InstrumentPlacement(
    id: 'keyboard',
    assetPath: 'assets/png/melody_mixer/instruments/keyboard.png',
    left: 0.07, top: 0.53, widthFactor: 0.45,
  ),
  InstrumentPlacement(
    id: 'chime_bars',
    assetPath: 'assets/png/melody_mixer/instruments/chime_bars.png',
    right: 0.04, top: 0.41, widthFactor: 0.41,
  ),
  InstrumentPlacement(
    id: 'hand_bells',
    assetPath: 'assets/png/melody_mixer/instruments/hand_bells.png',
    left: 0.48, top: 0.66, widthFactor: 0.34,
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


const _age9plusMoods = [
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

const reflectionTags = [
  ReflectionTag(
    id: 'just_for_fun',
    label: 'Just for\nFun',
    imageAsset: 'assets/png/melody_mixer/ui/justforfun_card.png',
  ),
  ReflectionTag(
    id: 'to_feel_stronger',
    label: 'To Feel\nStronger',
    imageAsset: 'assets/png/melody_mixer/ui/tofeelstronger_card.png',
  ),
  ReflectionTag(
    id: 'to_express_myself',
    label: 'To Express\nMyself',
    imageAsset: 'assets/png/melody_mixer/ui/toexpressmyself_card.png',
  ),
  ReflectionTag(
    id: 'to_relax_my_mind',
    label: 'To Relax My\nMind',
    imageAsset: 'assets/png/melody_mixer/ui/torelaxmymind_card.png',
  ),
];

// ── Config (9plus) ──
const age9plusConfig = MelodyMixerConfig(
  ageGroup: AgeGroup.age9plus,
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
  moods: _age9plusMoods, 
);