class CharacterStaticImageMap {
  static const Map<String, String> _imageByCharacterId = {
    'char_01': 'assets/png/prince_character.png',
    'char_02': 'assets/png/princes_character.png',
    'char_03': 'assets/png/knight_character.png',
    'char_04': 'assets/png/baby_dragon_character.png',
  };

  static const String _fallback = 'assets/png/prince_character.png';

  static String imageForCharacterId(String? characterId) {
    return _imageByCharacterId[characterId] ?? _fallback;
  }
}