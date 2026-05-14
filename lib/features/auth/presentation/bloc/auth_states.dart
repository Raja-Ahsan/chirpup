import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  final int selectedAvatarIndex;
  final String selectedAgeRange;

  const AuthStates({
    this.selectedAvatarIndex = 1,
    this.selectedAgeRange = '',
  });

  AuthStates copyWith({int? selectedAvatarIndex, String? selectedAgeRange}) {
    return AuthStates(
      selectedAvatarIndex: selectedAvatarIndex ?? this.selectedAvatarIndex,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
    );
  }

  @override
  List<Object?> get props => [selectedAvatarIndex, selectedAgeRange];
}
