const _base = 'assets/audio/melody_mixer';

/// Har instrument ke 3 alag tunes (same notes, alag order).
/// Ek tap = agla pattern (0 → 1 → 2 → 0 ...).
const instrumentPatterns = <String, List<List<String>>>{
  'piano': [
    ['$_base/piano_c4.wav', '$_base/piano_g4.wav', '$_base/piano_c5.wav'],
    ['$_base/piano_g3.wav', '$_base/piano_c4.wav', '$_base/piano_g4.wav'],
    ['$_base/piano_c5.wav', '$_base/piano_g4.wav', '$_base/piano_c4.wav'],
  ],
  'keyboard': [
    ['$_base/piano_c4.wav', '$_base/piano_g4.wav', '$_base/piano_c5.wav'],
    ['$_base/piano_g3.wav', '$_base/piano_c4.wav', '$_base/piano_g4.wav'],
    ['$_base/piano_c5.wav', '$_base/piano_g4.wav', '$_base/piano_c4.wav'],
  ],
  'xylophone': [
    [
      '$_base/xylophone_c5.wav',
      '$_base/xylophone_g5.wav',
      '$_base/xylophone_c6.wav',
    ],
    [
      '$_base/xylophone_c6.wav',
      '$_base/xylophone_g5.wav',
      '$_base/xylophone_c5.wav',
    ],
    [
      '$_base/xylophone_g5.wav',
      '$_base/xylophone_c5.wav',
      '$_base/xylophone_c6.wav',
    ],
  ],
  'chimebars': [
    [
      '$_base/chimebars_c3.wav',
      '$_base/chimebars_e3.wav',
      '$_base/chimebars_c4.wav',
    ],
    [
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_d4.wav',
      '$_base/chimebars_e3.wav',
    ],
    [
      '$_base/chimebars_d3.wav',
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_c3.wav',
    ],
  ],
  'chime_bars': [
    [
      '$_base/chimebars_c3.wav',
      '$_base/chimebars_e3.wav',
      '$_base/chimebars_c4.wav',
    ],
    [
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_d4.wav',
      '$_base/chimebars_e3.wav',
    ],
    [
      '$_base/chimebars_d3.wav',
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_c3.wav',
    ],
  ],
  'trumpet': [
    ['$_base/trumpet_c3.wav', '$_base/trumpet_g3.wav', '$_base/trumpet_c5.wav'],
    ['$_base/trumpet_d4.wav', '$_base/trumpet_f4.wav', '$_base/trumpet_c5.wav'],
    ['$_base/trumpet_c5.wav', '$_base/trumpet_g3.wav', '$_base/trumpet_c3.wav'],
  ],
  'violin': [
    ['$_base/violin_c4.wav', '$_base/violin_e4.wav', '$_base/violin_g4.wav'],
    ['$_base/violin_g4.wav', '$_base/violin_c5.wav', '$_base/violin_e5.wav'],
    ['$_base/violin_e5.wav', '$_base/violin_c5.wav', '$_base/violin_c4.wav'],
  ],
  'flute': [
    ['$_base/flute_c4.wav', '$_base/flute_e4.wav', '$_base/flute_a4.wav'],
    ['$_base/flute_a4.wav', '$_base/flute_c5.wav', '$_base/flute_e4.wav'],
    ['$_base/flute_c5.wav', '$_base/flute_a4.wav', '$_base/flute_c4.wav'],
  ],
  'bongo': [
    ['$_base/bongo_low.wav', '$_base/bongo_high.wav', '$_base/bongo_low.wav'],
    ['$_base/bongo_high.wav', '$_base/bongo_low.wav', '$_base/bongo_high.wav'],
    ['$_base/bongo_low.wav', '$_base/bongo_low.wav', '$_base/bongo_high.wav'],
  ],
  'bongos': [
    ['$_base/bongo_low.wav', '$_base/bongo_high.wav', '$_base/bongo_low.wav'],
    ['$_base/bongo_high.wav', '$_base/bongo_low.wav', '$_base/bongo_high.wav'],
    ['$_base/bongo_low.wav', '$_base/bongo_low.wav', '$_base/bongo_high.wav'],
  ],
  'bass_drum': [
    ['$_base/bass_drum.wav', '$_base/bass_drum.wav'],
    ['$_base/bass_drum.wav'],
    ['$_base/bass_drum.wav', '$_base/bass_drum.wav', '$_base/bass_drum.wav'],
  ],
  'drum': [
    ['$_base/bass_drum.wav', '$_base/bass_drum.wav'],
    ['$_base/bass_drum.wav'],
    ['$_base/bass_drum.wav', '$_base/bass_drum.wav', '$_base/bass_drum.wav'],
  ],
  // hand_bells — chimebars reuse (asli bell sound aane pe badal dena)
  'hand_bells': [
    [
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_e3.wav',
      '$_base/chimebars_c3.wav',
    ],
    [
      '$_base/chimebars_d4.wav',
      '$_base/chimebars_c4.wav',
      '$_base/chimebars_e3.wav',
    ],
    [
      '$_base/chimebars_e3.wav',
      '$_base/chimebars_d3.wav',
      '$_base/chimebars_c4.wav',
    ],
  ],
  // maracas — bongo (shaker) reuse (asli maraca sound aane pe badal dena)
  'maracas': [
    ['$_base/bongo_high.wav', '$_base/bongo_low.wav', '$_base/bongo_high.wav'],
    ['$_base/bongo_low.wav', '$_base/bongo_high.wav', '$_base/bongo_low.wav'],
    ['$_base/bongo_high.wav', '$_base/bongo_high.wav', '$_base/bongo_low.wav'],
  ],
};

List<String> get allSoundAssets => instrumentPatterns.values
    .expand((patterns) => patterns.expand((p) => p))
    .toSet()
    .toList();

const instrumentTailMs = <String, int>{
  'piano': 1000,
  'keyboard': 1000,
  'xylophone': 600,
  'chimebars': 1300, // 👈 1800 se 1000
  'chime_bars': 1300,
  'hand_bells': 1000, // 👈 kam
  'violin': 2000, // 👈 1500 se 700 (short)
  'trumpet': 2000, // 👈 900 se 600
  'flute': 2000, // 👈 kam
  'bongo': 200,
  'bongos': 200,
  'bass_drum': 200,
  'drum': 200,
};
