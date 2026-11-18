class AllChildrenModel {
  final List<Child> children;
  final bool success;
  final String message;
  final int code;

  AllChildrenModel({
    required this.children,
    required this.success,
    required this.message,
    required this.code,
  });

  factory AllChildrenModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final list = (data is Map ? data['children'] : null) as List? ?? [];

    return AllChildrenModel(
      children: list
          .map((e) => Child.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      code: json['code'] ?? 0,
    );
  }
}

class Child {
  final int? id;
  final int? userId;
  final String? name;
  final String? slug;
  final int? yearId;
  final int? characterId;
  final String? todayMood;
  final String? moodDate;
  final bool mood;
  final ChildProgress? progress;
  final String? status;
  final ChildYear? year;
  final ChildCharacter? character;
  final List<WeeklyMood> weeklyMood;
  final ChildUser? user;

  Child({
    this.id,
    this.userId,
    this.name,
    this.slug,
    this.yearId,
    this.characterId,
    this.todayMood,
    this.moodDate,
    this.mood = false,
    this.progress,
    this.status,
    this.year,
    this.character,
    this.weeklyMood = const [],
    this.user,
  });

  /// "5-6 Years"
  String get age => year?.title ?? '';

  /// Progress percent (0-100)
  double get progressPercent => progress?.progressPercent ?? 0;

  /// Character image URL
  String get characterImage => character?.imageUrl ?? '';

  /// Parent ka PIN set hai ya nahi (children response -> user.hasPin)
  bool get hasPin => user?.hasPin ?? false; // 👈 naya

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      userId: json['user_id'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      yearId: json['year_id'],
      characterId: json['character_id'],
      todayMood: json['today_mood']?.toString(),
      moodDate: json['mood_date']?.toString(),
      mood: json['mood'] == true,
      progress: json['progress'] != null
          ? ChildProgress.fromJson(json['progress'])
          : null,
      status: json['status']?.toString(),
      year: json['year'] != null ? ChildYear.fromJson(json['year']) : null,
      character: json['character'] != null
          ? ChildCharacter.fromJson(json['character'])
          : null,
      weeklyMood: (json['weekly_mood'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(WeeklyMood.fromJson)
          .toList(),
      user:
          json['user']
              is Map<String, dynamic> // 👈 naya
          ? ChildUser.fromJson(json['user'])
          : null,
    );
  }
}

/// 👈 naya — children response ke andar parent ka user object
class ChildUser {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final bool hasPin;
  final int totalChildrenProfiles;

  ChildUser({
    this.id,
    this.name,
    this.email,
    this.role,
    this.hasPin = false,
    this.totalChildrenProfiles = 0,
  });

  factory ChildUser.fromJson(Map<String, dynamic> json) {
    return ChildUser(
      id: json['id'],
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      // camelCase aur snake_case dono accept, taake key ka farq masla na kare
      hasPin: json['hasPin'] == true || json['has_pin'] == true,
      totalChildrenProfiles:
          (json['total_children_profiles'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeeklyMood {
  final String? moodDate;
  final ChildMood? mood;

  WeeklyMood({this.moodDate, this.mood});

  factory WeeklyMood.fromJson(Map<String, dynamic> json) {
    return WeeklyMood(
      moodDate: json['mood_date']?.toString(),
      mood: json['mood'] is Map<String, dynamic>
          ? ChildMood.fromJson(json['mood'])
          : null,
    );
  }
}

class ChildMood {
  final int? id;
  final String? name;
  final String? slug;
  final String? imageUrl;
  final String? description;
  final String? status;

  ChildMood({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
    this.description,
    this.status,
  });

  factory ChildMood.fromJson(Map<String, dynamic> json) {
    return ChildMood(
      id: json['id'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

class ChildProgress {
  final int stars;
  final int coins;
  final double progressPercent;

  ChildProgress({this.stars = 0, this.coins = 0, this.progressPercent = 0});

  factory ChildProgress.fromJson(Map<String, dynamic> json) {
    return ChildProgress(
      stars: (json['stars'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ChildYear {
  final int? id;
  final String? title;
  final String? slug;
  final String? status;

  ChildYear({this.id, this.title, this.slug, this.status});

  factory ChildYear.fromJson(Map<String, dynamic> json) {
    return ChildYear(
      id: json['id'],
      title: json['title']?.toString(),
      slug: json['slug']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

class ChildCharacter {
  final int? id;
  final String? name;
  final String? slug;
  final String? imageUrl;
  final String? description;
  final String? status;

  ChildCharacter({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
    this.description,
    this.status,
  });

  factory ChildCharacter.fromJson(Map<String, dynamic> json) {
    return ChildCharacter(
      id: json['id'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
