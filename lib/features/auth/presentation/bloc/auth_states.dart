import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  final int selectedAvatarIndex;
  final String selectedAgeRange;
  final String childName;
  final String enteredPin; 

  const AuthStates({
    this.selectedAvatarIndex = 1,
    this.selectedAgeRange = '',
    this.childName = '',
    this.enteredPin = '',
  });

  AuthStates copyWith({int? selectedAvatarIndex, String? selectedAgeRange, String? childName, String? enteredPin}) {
    return AuthStates(
      selectedAvatarIndex: selectedAvatarIndex ?? this.selectedAvatarIndex,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
      childName: childName ?? this.childName,
      enteredPin: enteredPin ?? this.enteredPin,
    );
  }

  @override
  List<Object?> get props => [selectedAvatarIndex, selectedAgeRange, childName, enteredPin];
}
