
import 'package:flutter/material.dart';

class MoodItem {
  final String label;
  final String imagePath;
  final Color bgColor;
  final Color selectedBgColor;

  const MoodItem({
    required this.label,
    required this.imagePath,
    required this.bgColor,
    required this.selectedBgColor
  });
}