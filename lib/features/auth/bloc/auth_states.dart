import 'package:chirp_up_app/features/auth/data/models/character_model.dart';
import 'package:equatable/equatable.dart';

const List<CharacterModel> kDefaultCharacters = [
  CharacterModel(
    id: "char_01",
    name: 'The Curious\nPrince Explorer',
    speciality: 'Brave and\nadventurous',
    imagePath: 'assets/png/prince_character.png',
    avatarImage: 'assets/png/prince_avatar.png'
  ),
  CharacterModel(
    id: "char_02",
    name: 'The Kind\nPrincess',
    speciality: 'Kind and\nthoughtful',
    imagePath: 'assets/png/princes_character.png',
    avatarImage: 'assets/png/princess_avatar.png'
  ),
  CharacterModel(
    id: "char_03",
    name: 'The Brave\nKnight',
    speciality: 'Strong and\ncourageous',
    imagePath: 'assets/png/knight_character.png',
    avatarImage: 'assets/png/knight_avatar.png'
  ),
  CharacterModel(
    id: "char_04",
    name: 'The Friendly\nDragon',
    speciality: 'Playful and\nnaughty',
    imagePath: 'assets/png/baby_dragon_character.png',
    avatarImage: 'assets/png/baby_dragon_avatar.png'
  ),
];

class AuthStates extends Equatable {
  final List<CharacterModel> characters;
  final int selectedCharacterIndex;
  final String selectedAgeRange;
  final String childName;
  final String enteredPin; 
  final bool isLoading;
  final bool isResendOTP;
  final bool isSkipPin;

  const AuthStates({
    this.characters = kDefaultCharacters,
    this.selectedCharacterIndex = 0,
    this.selectedAgeRange = '',
    this.childName = '',
    this.enteredPin = '',
    this.isLoading = false,
    this.isResendOTP = false,
    this.isSkipPin = false,
  });

  // Convenience getter
  CharacterModel get selectedCharacter => characters[selectedCharacterIndex];

  AuthStates copyWith({List<CharacterModel>? characters,int? selectedCharacterIndex, String? selectedAgeRange, String? childName, String? enteredPin, bool? isLoading,bool? isResendOTP, bool? isSkipPin}) {
    return AuthStates(
      characters: characters ?? this.characters,
      selectedCharacterIndex: selectedCharacterIndex ?? this.selectedCharacterIndex,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
      childName: childName ?? this.childName,
      enteredPin: enteredPin ?? this.enteredPin,
      isLoading: isLoading ?? this.isLoading,
      isResendOTP: isResendOTP ?? this.isResendOTP,
      isSkipPin: isSkipPin ?? this.isSkipPin,
    );
  }

  @override
  List<Object?> get props => [characters,selectedCharacterIndex, selectedAgeRange, childName, enteredPin, isLoading, isResendOTP,isSkipPin];
}
