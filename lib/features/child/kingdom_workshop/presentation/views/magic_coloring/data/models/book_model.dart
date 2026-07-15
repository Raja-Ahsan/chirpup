class BookModel {
  final String id;
  final String type; // 'sketchesBook' | 'myDrawingBook' | 'characterStudioBook'
  final String title;
  final String? coverImageUrl;

  const BookModel({
    required this.id,
    required this.type,
    required this.title,
    this.coverImageUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'coverImageUrl': coverImageUrl,
      };
}