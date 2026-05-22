import 'package:equatable/equatable.dart';

abstract class MoodSelectionEvents extends Equatable {
  const MoodSelectionEvents();
  @override
  List<Object?> get props => [];
}

class SelectMoodEvent extends MoodSelectionEvents {
  final int index;
  const SelectMoodEvent(this.index);
  @override
  List<Object?> get props => [index];
}
