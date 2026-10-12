import 'package:chirp_up_app/core/constants/age_group.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_3to4_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_5to6_config.dart';

import '../models/melody_mixer_config_model.dart';
import 'age_1to2_config.dart';

class MelodyMixerCapabilityConfig {
  static MelodyMixerConfig forAge(AgeGroup age) {
    switch (age) {
      case AgeGroup.age1to2:
        return age1to2Config;
      case AgeGroup.age3to4:
        return age3to4Config;
      case AgeGroup.age5to6:
        return age5to6Config;
      default:
        return age1to2Config;
    }
  }
}
