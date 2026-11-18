class ChildDashboardModel {
  ChildDashboardModel({
    this.id,
    this.slug,
    this.name,
    this.age,
    this.yearId,
    this.characterId,
    this.stars,
    this.points,
    this.progressPercent,
    this.todayMoodId,
    this.moodDate,
    this.todayMoodSlug,
  });

  final String? id;
  final String? slug;
  final String? name;
  final String? age; // year.title, jaise "1-2 Years"
  final int? yearId; // 👈 naya: games API ke liye
  final String? characterId; // 'char_01' format
  final int? stars;
  final int? points; // progress.coins
  final int? progressPercent;
  final int? todayMoodId;
  final String? moodDate;
  final String? todayMoodSlug;

  factory ChildDashboardModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> progress = json['progress'] is Map
        ? Map<String, dynamic>.from(json['progress'])
        : {};
    final Map<String, dynamic> year = json['year'] is Map
        ? Map<String, dynamic>.from(json['year'])
        : {};

    final int? rawCharacterId = json['character_id'] is int
        ? json['character_id']
        : int.tryParse('${json['character_id']}');

    // year_id seedha child par hai, warna year object ki id
    final int? yearId = json['year_id'] is int
        ? json['year_id']
        : (int.tryParse('${json['year_id']}') ?? int.tryParse('${year['id']}'));

    final String? moodDate = json['mood_date']?.toString();

    String? todayMoodSlug;
    final weekly = json['weekly_mood'];
    if (weekly is List) {
      for (final w in weekly) {
        if (w is Map &&
            w['mood_date']?.toString() == moodDate &&
            w['mood'] is Map) {
          todayMoodSlug = w['mood']['slug']?.toString().toLowerCase();
          break;
        }
      }
    }

    return ChildDashboardModel(
      id: json['id']?.toString(),
      slug: json['slug']?.toString(),
      name: json['name']?.toString(),
      age: year['title']?.toString(),
      yearId: yearId,
      characterId: rawCharacterId != null
          ? 'char_${rawCharacterId.toString().padLeft(2, '0')}'
          : null,
      stars: (progress['stars'] as num?)?.toInt() ?? 0,
      points: (progress['coins'] as num?)?.toInt() ?? 0,
      progressPercent: (progress['progress_percent'] as num?)?.toInt() ?? 0,
      todayMoodId: int.tryParse('${json['today_mood']}'),
      moodDate: moodDate,
      todayMoodSlug: todayMoodSlug,
    );
  }
}