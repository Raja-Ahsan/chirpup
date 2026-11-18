class GameModel {
  final int id;
  final String name;
  final String slug;
  final int gameCategoryId;
  final String imageUrl;
  final String description;
  final String status;
  final bool isBook;
  final GameCategoryInfo? category;

  const GameModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.gameCategoryId,
    required this.imageUrl,
    required this.description,
    required this.status,
    required this.isBook,
    this.category,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawCategory = json['category'];
    return GameModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      gameCategoryId: json['game_category_id'] is int
          ? json['game_category_id']
          : int.tryParse('${json['game_category_id']}') ?? 0,
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isBook: json['is_book'] == true,
      category: rawCategory is Map
          ? GameCategoryInfo.fromJson(Map<String, dynamic>.from(rawCategory))
          : null,
    );
  }
}

class GameCategoryInfo {
  final int id;
  final String title;
  final String slug;
  final String imageUrl;
  final String description;
  final String status;

  const GameCategoryInfo({
    required this.id,
    required this.title,
    required this.slug,
    required this.imageUrl,
    required this.description,
    required this.status,
  });

  factory GameCategoryInfo.fromJson(Map<String, dynamic> json) {
    return GameCategoryInfo(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}