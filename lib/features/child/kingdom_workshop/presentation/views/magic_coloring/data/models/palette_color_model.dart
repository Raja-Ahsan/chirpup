import 'package:flutter/material.dart';

class PaletteColor {
  final String id;
  final Color color;
  final bool isGlitter;

  const PaletteColor({required this.id, required this.color, this.isGlitter = false});

  Map<String, dynamic> toJson() => {'id': id, 'color': color.value, 'isGlitter': isGlitter};

  factory PaletteColor.fromJson(Map<String, dynamic> json) => PaletteColor(
        id: json['id'] as String,
        color: Color(json['color'] as int),
        isGlitter: json['isGlitter'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) =>
      other is PaletteColor && other.id == id && other.color.value == color.value && other.isGlitter == isGlitter;

  @override
  int get hashCode => Object.hash(id, color.value, isGlitter);
}

// ── Dummy palettes ──
class ColoringPalettes {
  static const List<PaletteColor> normal = [
    PaletteColor(id: 'blue', color: Color(0xff4A90D9)),
    PaletteColor(id: 'yellow', color: Color(0xffF5E642)),
    PaletteColor(id: 'green', color: Color(0xff1B7A4A)),
    PaletteColor(id: 'red', color: Color(0xffD94040)),
    PaletteColor(id: 'purple', color: Color(0xffB06ED4)),
    PaletteColor(id: 'teal', color: Color(0xff4FD1C5)),
    PaletteColor(id: 'lime', color: Color(0xff5AAD2E)),
  ];

  static const List<PaletteColor> glitter = [
    PaletteColor(id: 'glitter_blue', color: Color(0xff4A90D9), isGlitter: true),
    PaletteColor(id: 'glitter_yellow', color: Color(0xffF5E642), isGlitter: true),
    PaletteColor(id: 'glitter_green', color: Color(0xff1B7A4A), isGlitter: true),
    PaletteColor(id: 'glitter_red', color: Color(0xffD94040), isGlitter: true),
    PaletteColor(id: 'glitter_purple', color: Color(0xffB06ED4), isGlitter: true),
    PaletteColor(id: 'glitter_teal', color: Color(0xff4FD1C5), isGlitter: true),
    PaletteColor(id: 'glitter_lime', color: Color(0xff5AAD2E), isGlitter: true),
  ];
}