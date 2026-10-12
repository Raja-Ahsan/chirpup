import 'package:chirp_up_app/core/constants/age_group.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_enums.dart';

import '../models/melody_mixer_config_model.dart';

const age1to2MusicHallInstruments = [
  InstrumentPlacement(
    id: 'violin',
    assetPath: 'assets/png/melody_mixer/instruments/violin.png',
    right: 0.0, top: 0.24, widthFactor: 0.32, playable: false,
  ),
  InstrumentPlacement(
    id: 'xylophone',
    assetPath: 'assets/png/melody_mixer/instruments/xylophone.png',
    left: 0.10, top: 0.54, widthFactor: 0.68,
  ),
  InstrumentPlacement(
    id: 'bass_drum',
    assetPath: 'assets/png/melody_mixer/instruments/bass_drum.png',
    left: 0.14, top: 0.70, widthFactor: 0.55,
  ),
];

const age1to2Config = MelodyMixerConfig(
  ageGroup: AgeGroup.age1to2,
  entry: MixerEntry.direct,
  flow: [MixerStage.intro, MixerStage.play, MixerStage.celebration],
  interaction: InteractionMode.freePlay,
  moodSelectionEnabled: false,
  recordingEnabled: false,
  persistence: false,
  questsEnabled: false,
  reflectionEnabled: false,
  defaultBackgroundAsset: 'assets/melody_mixer/backgrounds/music_hall.png',
);