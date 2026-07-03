import 'package:flutter/material.dart';

class GameItem {
  final String key;
  final String label;
  final String imagePath;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;

  const GameItem({
    required this.key,
    required this.label,
    required this.imagePath,
    required this.bgColor,
    required this.textColor,
    required this.shadowColor,
  });
}