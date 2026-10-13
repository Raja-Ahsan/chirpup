import 'package:chirp_up_app/features/auth/data/models/character_model.dart';
import 'package:chirp_up_app/features/auth/data/models/year_model.dart';
import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  final List<CharacterModel> characters;
  final int selectedCharacterIndex;
  final bool isCharactersLoading;

  final List<YearModel> years;
  final int? selectedYearIndex;
  final bool isYearsLoading;

  final String childName;
  final String enteredPin;
  final bool isLoading;
  final bool isResendOTP;
  final bool isSkipPin;

  const AuthStates({
    this.characters = const [],
    this.selectedCharacterIndex = 0,
    this.isCharactersLoading = true,
    this.years = const [],
    this.selectedYearIndex,
    this.isYearsLoading = true,
    this.childName = '',
    this.enteredPin = '',
    this.isLoading = false,
    this.isResendOTP = false,
    this.isSkipPin = false,
  });

  CharacterModel? get selectedCharacter =>
      (characters.isNotEmpty && selectedCharacterIndex < characters.length)
          ? characters[selectedCharacterIndex]
          : null;

  YearModel? get selectedYear =>
      (selectedYearIndex != null &&
          selectedYearIndex! >= 0 &&
          selectedYearIndex! < years.length)
          ? years[selectedYearIndex!]
          : null;

  AuthStates copyWith({
    List<CharacterModel>? characters,
    int? selectedCharacterIndex,
    bool? isCharactersLoading,
    List<YearModel>? years,
    int? selectedYearIndex,
    bool clearSelectedYear = false,
    bool? isYearsLoading,
    String? childName,
    String? enteredPin,
    bool? isLoading,
    bool? isResendOTP,
    bool? isSkipPin,
  }) {
    return AuthStates(
      characters: characters ?? this.characters,
      selectedCharacterIndex:
          selectedCharacterIndex ?? this.selectedCharacterIndex,
      isCharactersLoading: isCharactersLoading ?? this.isCharactersLoading,
      years: years ?? this.years,
      selectedYearIndex: clearSelectedYear
          ? null
          : (selectedYearIndex ?? this.selectedYearIndex),
      isYearsLoading: isYearsLoading ?? this.isYearsLoading,
      childName: childName ?? this.childName,
      enteredPin: enteredPin ?? this.enteredPin,
      isLoading: isLoading ?? this.isLoading,
      isResendOTP: isResendOTP ?? this.isResendOTP,
      isSkipPin: isSkipPin ?? this.isSkipPin,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    selectedCharacterIndex,
    isCharactersLoading,
    years,
    selectedYearIndex,
    isYearsLoading,
    childName,
    enteredPin,
    isLoading,
    isResendOTP,
    isSkipPin,
  ];
}
