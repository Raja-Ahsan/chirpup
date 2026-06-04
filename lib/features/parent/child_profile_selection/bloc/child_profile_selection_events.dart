import 'package:equatable/equatable.dart';

abstract class ChildProfileSelectionEvents extends Equatable {
  const ChildProfileSelectionEvents();
  @override
  List<Object?> get props => [];
}

class SelectChildProfileEvent extends ChildProfileSelectionEvents {
  final int index;
  const SelectChildProfileEvent(this.index);
  @override
  List<Object?> get props => [index];
}