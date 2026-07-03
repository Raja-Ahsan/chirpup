import 'package:flutter/material.dart';
import 'models/game_item_model.dart';

class GamesData {
  static const List<GameItem> allGames = [
    GameItem(
      key: 'breathing',
      label: 'Breath of\nKingdom',
      imagePath: 'assets/png/suggestion_dragon.png',
      bgColor: Color(0xffD6E4F1),
      textColor: Color(0xff3889E8),
      shadowColor: Colors.white,
    ),
    GameItem(
      key: 'coloring',
      label: 'Magic\nColoring',
      imagePath: 'assets/png/suggestion_coloring.png',
      bgColor: Color(0xffFFC8AE),
      textColor: Color(0xffC8311A),
      shadowColor: Colors.white,
    ),
    GameItem(
      key: 'castle',
      label: 'Castle\nBuilder',
      imagePath: 'assets/png/suggestion_castle.png',
      bgColor: Color(0xffF6E6D7),
      textColor: Color(0xffFFB900),
      shadowColor: Color(0xff433717),
    ),
    GameItem(
      key: 'melody',
      label: 'Melody\nMixer',
      imagePath: 'assets/png/suggestion_melody.png',
      bgColor: Color(0xffD6D9F8),
      textColor: Color(0xff7B6CF4),
      shadowColor: Colors.white,
    ),
    GameItem(
      key: 'gratitude',
      label: 'Gratitude\nGarden',
      imagePath: 'assets/png/suggesstion_garden.png',
      bgColor: Color(0xffD6E9D0),
      textColor: Color(0xff7FAB32),
      shadowColor: Colors.white,
    ),
  ];

  static const Map<String, List<String>> moodToGameKeys = {
    'Happy': ['castle', 'melody'],
    'Calm': ['coloring', 'gratitude'],
    'Sleepy': ['breathing', 'coloring'],
    'Angry': ['breathing', 'castle'],
    'Sad': ['gratitude', 'melody'],
  };

  static List<GameItem> gamesForMood(String moodLabel) {
    final keys = moodToGameKeys[moodLabel] ?? [];
    return allGames.where((g) => keys.contains(g.key)).toList();
  }
}
