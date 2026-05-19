import 'package:chirp_up_app/features/parent/dashboard/data/models/child_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChildProfileSelectionEvents extends Equatable {
  const ChildProfileSelectionEvents();
  @override
  List<Object?> get props => [];
}

class InitChildSelectionEvent extends ChildProfileSelectionEvents {
  final List<ChildModel> children;
  final int selectedIndex;
  const InitChildSelectionEvent({
    required this.children,
    required this.selectedIndex,
  });
  @override
  List<Object?> get props => [children, selectedIndex];
}

class SelectChildProfileEvent extends ChildProfileSelectionEvents {
  final int index;
  const SelectChildProfileEvent(this.index);
  @override
  List<Object?> get props => [index];
}