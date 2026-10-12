class CharacterStaticImageMap {
  static const Map<String, String> _imageByCharacterId = {
    'char_01': 'assets/png/prince_character.png',
    'char_02': 'assets/png/princes_character.png',
    'char_03': 'assets/png/knight_character.png',
    'char_04': 'assets/png/baby_dragon_character.png',
  };

  static const Map<String, String> _lottieByCharacterId = {
    'char_01': 'assets/lotties/prince_idle_lottie.json',
    'char_02': 'assets/lotties/princess_idle_lottie.json',
    'char_03': 'assets/lotties/knight_lottie.json',
    'char_04': 'assets/lotties/dragon_lottie.json',
  };

  static const Map<String, String> _winnigLottieByCharacterId = {
    'char_01': 'assets/lotties/prince_winning_lottie.json',
    'char_02': 'assets/lotties/princes_winning_lottie.json',
    'char_03': 'assets/lotties/prince_winning_lottie.json',
    'char_04': 'assets/lotties/prince_winning_lottie.json',
  };

  static const String _fallback = 'assets/png/prince_character.png';
  static const String _fallbackLottie = 'assets/lotties/dragon_lottie.json';
  static const String _fallbackWinningLottie = 'assets/lotties/prince_winning_lottie.json';

  static String imageForCharacterId(String? characterId) {
    return _imageByCharacterId[characterId] ?? _fallback;
  }

  static String lottieForCharacterId(String? characterId) {
    return _lottieByCharacterId[characterId] ?? _fallbackLottie;
  }

  static String winningLottieForCharacterId(String? id) {
    if (id == null) return _fallbackWinningLottie;
    return _winnigLottieByCharacterId[id] ?? _fallbackWinningLottie;
  }
}
