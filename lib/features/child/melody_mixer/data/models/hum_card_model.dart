import 'melody_mixer_enums.dart';

class HubCard {
  final MixerFlowId flow;
  final String title;
  final String iconAsset;

  const HubCard({
    required this.flow,
    required this.title,
    required this.iconAsset,
  });
}