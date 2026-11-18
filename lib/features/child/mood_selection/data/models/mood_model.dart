import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MoodModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;
  final String description;
  final String status;

  const MoodModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.description,
    required this.status,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  // API colors nahi bhejti, isliye design wale colors slug se map hain
  static const Map<String, Color> _bgColors = {
    'happy': Color(0xffEFEAD4),
    'calm': Color(0xffD6E4F0),
    'sleepy': Color(0xffD5E0F0),
    'angry': Color(0xffEEDFDF),
    'sad': Color(0xffD9E1E4),
  };

  static const Map<String, Color> _selectedBgColors = {
    'happy': Color(0xffF9C846),
    'calm': Color(0xff73B1F9),
    'sleepy': Color(0xff496DCD),
    'angry': Color(0xffF295A4),
    'sad': Color(0xffA5B6CD),
  };

  Color get bgColor => _bgColors[slug] ?? const Color(0xffE6ECEF);
  Color get selectedBgColor =>
      _selectedBgColors[slug] ?? const Color(0xff9FB4C7);

  @override
  List<Object?> get props => [id, name, slug, imageUrl, description, status];
}