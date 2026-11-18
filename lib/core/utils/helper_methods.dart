class HelperMethods {
  String imagePathFromCharacterId(String? characterId) {
    switch (characterId) {
      case '1':
        return 'assets/png/prince_character.png';
      case '2':
        return 'assets/png/princes_character.png';
      case '3':
        return 'assets/png/knight_character.png';
      case '4':
        return 'assets/png/baby_dragon_character.png';
      default:
        return 'assets/png/prince_character.png';
    }
  }

  String characterSpecialityFromCharacterId(String? characterId) {
  switch (characterId) {
    case '1': return 'Brave and\nadventurous';
    case '2': return 'Kind and\nthoughtful';
    case '3': return 'Strong and\ncourageous';
    case '4': return 'Playful and\nnaughty';
    default:        return '';
  }
}
}
