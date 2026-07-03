class HelperMethods {
  String imagePathFromCharacterId(String? characterId) {
    switch (characterId) {
      case 'char_01':
        return 'assets/png/prince_character.png';
      case 'char_02':
        return 'assets/png/princes_character.png';
      case 'char_03':
        return 'assets/png/knight_character.png';
      case 'char_04':
        return 'assets/png/baby_dragon_character.png';
      default:
        return 'assets/png/prince_character.png';
    }
  }

  String characterSpecialityFromCharacterId(String? characterId) {
  switch (characterId) {
    case 'char_01': return 'Brave and\nadventurous';
    case 'char_02': return 'Kind and\nthoughtful';
    case 'char_03': return 'Strong and\ncourageous';
    case 'char_04': return 'Playful and\nnaughty';
    default:        return '';
  }
}
}
