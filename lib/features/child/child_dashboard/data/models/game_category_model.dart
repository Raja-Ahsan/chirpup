import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_model.dart';
import 'package:equatable/equatable.dart';

class GameCategoryModel extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String imageUrl;
  final String description;
  final String status;
  final List<MoodModel> moods;

  const GameCategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.imageUrl,
    required this.description,
    required this.status,
    this.moods = const [],
  });

  factory GameCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawMoods = json['moods'];
    return GameCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      moods: rawMoods is List
          ? rawMoods
                .whereType<Map>()
                .map((e) => MoodModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
    );
  }

  @override
  List<Object?> get props =>
      [id, title, slug, imageUrl, description, status, moods];
}