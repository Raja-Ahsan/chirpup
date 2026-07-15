import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';

class MyDrawingEntryModel {
  final String id;
  final String childId;
  final String? sourceSketchId;
  final String coloredImageUrl;
  final Map<int, PaletteColor> regionColors;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MyDrawingEntryModel({
    required this.id,
    required this.childId,
    this.sourceSketchId,
    required this.coloredImageUrl,
    this.regionColors = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyDrawingEntryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawColors =
        (json['regionColors'] as Map? ?? {}).cast<String, dynamic>();

    return MyDrawingEntryModel(
      id: json['id'] as String,
      childId: json['childId'] as String,
      sourceSketchId: json['sourceSketchId'] as String?,
      coloredImageUrl: json['coloredImageUrl'] as String,
      regionColors: rawColors.map(
        (id, paletteJson) => MapEntry(
          int.parse(id),
          PaletteColor.fromJson((paletteJson as Map).cast<String, dynamic>()),
        ),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'sourceSketchId': sourceSketchId,
        'coloredImageUrl': coloredImageUrl,
        'regionColors': regionColors.map(
          (id, palette) => MapEntry(id.toString(), palette.toJson()),
        ),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}