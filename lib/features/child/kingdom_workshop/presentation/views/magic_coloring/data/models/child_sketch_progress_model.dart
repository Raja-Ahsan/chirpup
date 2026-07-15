import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';

class ChildSketchProgressModel {
  final String childId;
  final String sketchTemplateId;
  final String? coloredImageUrl;
  final Map<int, PaletteColor> regionColors;
  final bool isCompleted;
  final bool rewardClaimed;
  final DateTime? updatedAt;

  const ChildSketchProgressModel({
    required this.childId,
    required this.sketchTemplateId,
    this.coloredImageUrl,
    this.regionColors = const {},
    this.isCompleted = false,
    this.rewardClaimed = false,
    this.updatedAt,
  });

  ChildSketchProgressModel copyWith({
    String? coloredImageUrl,
    Map<int, PaletteColor>? regionColors,
    bool? isCompleted,
    bool? rewardClaimed,
    DateTime? updatedAt,
  }) {
    return ChildSketchProgressModel(
      childId: childId,
      sketchTemplateId: sketchTemplateId,
      coloredImageUrl: coloredImageUrl ?? this.coloredImageUrl,
      regionColors: regionColors ?? this.regionColors,
      isCompleted: isCompleted ?? this.isCompleted,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChildSketchProgressModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawColors =
        (json['regionColors'] as Map? ?? {}).cast<String, dynamic>();

    return ChildSketchProgressModel(
      childId: json['childId'] as String? ?? '',
      sketchTemplateId: json['sketchId'] as String,
      coloredImageUrl: json['coloredImageUrl'] as String?,
      regionColors: rawColors.map(
        (id, paletteJson) => MapEntry(
          int.parse(id),
          PaletteColor.fromJson((paletteJson as Map).cast<String, dynamic>()),
        ),
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      rewardClaimed: json['rewardClaimed'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'sketchId': sketchTemplateId,
        'coloredImageUrl': coloredImageUrl,
        'regionColors': regionColors.map(
          (id, palette) => MapEntry(id.toString(), palette.toJson()),
        ),
        'isCompleted': isCompleted,
        'rewardClaimed': rewardClaimed,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}