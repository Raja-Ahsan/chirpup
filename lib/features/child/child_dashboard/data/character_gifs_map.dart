class CharacterGifMap {
  static const Map<String, String> _gifByCharacterId = {
    'char_01': 'assets/gifs/prince.gif',
    'char_02': 'assets/gifs/princess.gif',
    'char_03': 'assets/gifs/knight.gif',
    'char_04': 'assets/gifs/baby_dragon.gif',
  };

  static const Map<String, String> _quoteByCharacterId = {
    'char_01': "I am brave,\neven when\nthings feel tricky.",
    'char_02': "I am kind,\neven when\nit's hard\nto be.",
    'char_03': "I am strong,\neven when\nI feel a little scared.",
    'char_04': "I am playful,\nand that's\nokay\ntoo.",
  };

  static const String _fallbackGif = 'assets/gifs/baby_dragon.gif';
  static const String _fallbackQuote = "I am me, and\nthat's pretty great.";

  static String gifForCharacterId(String? characterId) {
    return _gifByCharacterId[characterId] ?? _fallbackGif;
  }

  static String quoteForCharacterId(String? characterId) {
    return _quoteByCharacterId[characterId] ?? _fallbackQuote;
  }
}
