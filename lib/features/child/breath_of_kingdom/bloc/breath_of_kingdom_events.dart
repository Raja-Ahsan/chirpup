import 'package:equatable/equatable.dart';

abstract class BreathOfKingdomEvents extends Equatable {
  const BreathOfKingdomEvents();
  @override
  List<Object?> get props => [];
}

class SelectCharacterEvent extends BreathOfKingdomEvents {
  final int index;
  const SelectCharacterEvent(this.index);

  @override
  List<Object?> get props => [index];
}
