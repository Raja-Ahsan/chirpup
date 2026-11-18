class GameCategoriesModel {
  final List<GameCategory> categories;
  final bool success;
  final String message;
  final int code;

  GameCategoriesModel({
    required this.categories,
    required this.success,
    required this.message,
    required this.code,
  });

  factory GameCategoriesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final list = (data is Map ? data['categories'] : null) as List? ?? [];

    return GameCategoriesModel(
      categories: list
          .whereType<Map<String, dynamic>>()
          .map(GameCategory.fromJson)
          .toList(),
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      code: json['code'] ?? 0,
    );
  }
}

class GameCategory {
  final int? id;
  final String? title;
  final String? slug;
  final String? imageUrl;
  final String? description;
  final String? status;

  /// Backend abhi ye key nahi bhej raha, to default 0
  final int weeklyPlay;

  final List<GameMood> moods;

  GameCategory({
    this.id,
    this.title,
    this.slug,
    this.imageUrl,
    this.description,
    this.status,
    this.weeklyPlay = 0,
    this.moods = const [],
  });

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      id: json['id'],
      title: json['title']?.toString(),
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      // num / String dono handle honge, key na ho to 0
      weeklyPlay: num.tryParse(json['weekly_play']?.toString() ?? '')?.toInt() ?? 0,
      moods: (json['moods'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(GameMood.fromJson)
          .toList(),
    );
  }
}

class GameMood {
  final int? id;
  final String? name;
  final String? slug;
  final String? imageUrl;
  final String? description;
  final String? status;

  GameMood({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
    this.description,
    this.status,
  });

  factory GameMood.fromJson(Map<String, dynamic> json) {
    return GameMood(
      id: json['id'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }
}