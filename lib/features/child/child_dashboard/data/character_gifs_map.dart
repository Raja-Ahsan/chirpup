class CharacterGifMap {
  static const Map<String, String> _lottieByCharacterId = {
    'char_01': 'assets/lotties/prince_idle_lottie.json',
    'char_02': 'assets/lotties/princess_idle_lottie.json',
    'char_03': 'assets/lotties/knight_lottie.json',
    'char_04': 'assets/lotties/dragon_lottie.json',
  };

  static const Map<String, String> _quoteByCharacterId = {
    'char_01': "I am brave,\neven when\nthings feel tricky.",
    'char_02': "I am kind,\neven when\nit's hard\nto be.",
    'char_03': "I am strong,\neven when\nI feel a little scared.",
    'char_04': "I am playful,\nand that's\nokay\ntoo.",
  };

  static const String _fallbackLottie = 'assets/lotties/dragon_lottie.json';
  static const String _fallbackQuote = "I am me, and\nthat's pretty great.";

  static String lottieForCharacterId(String? characterId) {
    return _lottieByCharacterId[characterId] ?? _fallbackLottie;
  }

  static String quoteForCharacterId(String? characterId) {
    return _quoteByCharacterId[characterId] ?? _fallbackQuote;
  }
}
