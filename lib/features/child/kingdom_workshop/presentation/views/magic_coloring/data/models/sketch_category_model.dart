class SketchCategoryModel {
  final String id;
  final String iconPath;

  const SketchCategoryModel({
    required this.id,
    required this.iconPath,
  });

  factory SketchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SketchCategoryModel(
      id: json['id'] as String,
      iconPath: json['iconPath'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'iconPath': iconPath};
}