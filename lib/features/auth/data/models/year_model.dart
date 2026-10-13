class YearModel {
  final int id;
  final String title;
  final String slug;

  const YearModel({
    required this.id,
    required this.title,
    required this.slug,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}