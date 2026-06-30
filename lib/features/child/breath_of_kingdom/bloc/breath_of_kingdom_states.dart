import 'package:chirp_up_app/features/auth/data/models/character_model.dart';
import 'package:equatable/equatable.dart';

const List<CharacterModel> kDefaultCharacters = [
  CharacterModel(
    id: "char_01",
    name: 'The Curious\nPrince Explorer',
    speciality: 'Brave and\nadventurous',
    imagePath: 'assets/png/prince_character.png',
    avatarImage: 'assets/png/prince_avatar.png',
  ),
  CharacterModel(
    id: "char_02",
    name: 'The Kind\nPrincess',
    speciality: 'Kind and\nthoughtful',
    imagePath: 'assets/png/princes_character.png',
    avatarImage: 'assets/png/princess_avatar.png',
  ),
  CharacterModel(
    id: "char_03",
    name: 'The Brave\nKnight',
    speciality: 'Strong and\ncourageous',
    imagePath: 'assets/png/knight_character.png',
    avatarImage: 'assets/png/knight_avatar.png',
  ),
  CharacterModel(
    id: "char_04",
    name: 'The Friendly\nDragon',
    speciality: 'Playful and\nnaughty',
    imagePath: 'assets/png/baby_dragon_character.png',
    avatarImage: 'assets/png/baby_dragon_avatar.png',
  ),
];

class BreathOfKingdomStates extends Equatable {
  final List<CharacterModel> characters;
  final int selectedCharacterIndex;

  const BreathOfKingdomStates({
    this.characters = kDefaultCharacters,
    this.selectedCharacterIndex = 0,
  });

  // Convenience getter
  CharacterModel get selectedCharacter => characters[selectedCharacterIndex];

  BreathOfKingdomStates copyWith({
    List<CharacterModel>? characters,
    int? selectedCharacterIndex,
    String? selectedAgeRange,
    String? childName,
    String? enteredPin,
  }) {
    return BreathOfKingdomStates(
      characters: characters ?? this.characters,
      selectedCharacterIndex:
          selectedCharacterIndex ?? this.selectedCharacterIndex,
    );
  }

  @override
  List<Object?> get props => [characters, selectedCharacterIndex];
}
