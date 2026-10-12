import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:flutter/material.dart';

class MoodConfig {
  final String id;
  final String label;
  final String iconAsset;
  final Color cardColor;
  final String roomBackgroundAsset;
  final List<InstrumentPlacement> instruments;
  final Color badgeColor;
  final String? cardImageAsset;
  final String? cardBgAsset;
  final Color labelColor;

  const MoodConfig({
    required this.id,
    required this.label,
    required this.iconAsset,
    required this.cardColor,
    required this.roomBackgroundAsset,
    required this.instruments,
    required this.badgeColor,
    this.cardImageAsset,
    this.cardBgAsset,
    this.labelColor = const Color(0xFF645973),
  });
}