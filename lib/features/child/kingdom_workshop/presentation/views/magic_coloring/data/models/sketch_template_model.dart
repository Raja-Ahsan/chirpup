class SketchTemplateModel {
  final String id;
  final String bookId;
  final String categoryId;
  final String name;
  final String assetUrl;
  final String thumbnailUrl;
  final bool isLocked;

  const SketchTemplateModel({
    required this.id,
    required this.bookId,
    required this.categoryId,
    required this.name,
    required this.assetUrl,
    required this.thumbnailUrl,
    this.isLocked = false,
  });

  factory SketchTemplateModel.fromJson(Map<String, dynamic> json) {
    return SketchTemplateModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      assetUrl: json['assetUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'categoryId': categoryId,
        'name': name,
        'assetUrl': assetUrl,
        'thumbnailUrl': thumbnailUrl,
        'isLocked': isLocked,
      };
}