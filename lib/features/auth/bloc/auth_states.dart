import 'package:chirp_up_app/features/auth/data/models/character_model.dart';
import 'package:equatable/equatable.dart';

const List<CharacterModel> kDefaultCharacters = [
  CharacterModel(
    name: 'The Curious\nPrince Explorer',
    speciality: 'Brave and\nadventurous',
    imagePath: 'assets/png/prince_character.png',
  ),
  CharacterModel(
    name: 'The Kind\nPrincess',
    speciality: 'Kind and\nthoughtful',
    imagePath: 'assets/png/princes_character.png',
  ),
  CharacterModel(
    name: 'The Brave\nKnight',
    speciality: 'Strong and\ncourageous',
    imagePath: 'assets/png/knight_character.png',
  ),
  CharacterModel(
    name: 'The Friendly\nDragon',
    speciality: 'Playful and\nnaughty',
    imagePath: 'assets/png/baby_dragon_character.png',
  ),
];

class AuthStates extends Equatable {
  final List<CharacterModel> characters;
  final int selectedCharacterIndex;
  final String selectedAgeRange;
  final String childName;
  final String enteredPin; 

  const AuthStates({
    this.characters = kDefaultCharacters,
    this.selectedCharacterIndex = 0,
    this.selectedAgeRange = '',
    this.childName = '',
    this.enteredPin = '',
  });

  // Convenience getter
  CharacterModel get selectedCharacter => characters[selectedCharacterIndex];

  AuthStates copyWith({List<CharacterModel>? characters,int? selectedCharacterIndex, String? selectedAgeRange, String? childName, String? enteredPin}) {
    return AuthStates(
      characters: characters ?? this.characters,
      selectedCharacterIndex: selectedCharacterIndex ?? this.selectedCharacterIndex,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
      childName: childName ?? this.childName,
      enteredPin: enteredPin ?? this.enteredPin,
    );
  }

  @override
  List<Object?> get props => [characters,selectedCharacterIndex, selectedAgeRange, childName, enteredPin];
}
