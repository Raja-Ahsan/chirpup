import 'package:chirp_up_app/features/parent/dashboard/data/models/child_model.dart';
import 'package:equatable/equatable.dart';

class ChildProfileSelectionStates extends Equatable {
  final int selectedChildIndex;
  final List<ChildModel> children;

  const ChildProfileSelectionStates({
    this.selectedChildIndex = 0,
    this.children = const [],
  });

  ChildProfileSelectionStates copyWith({
    int? selectedChildIndex,
    List<ChildModel>? children,
  }) {
    return ChildProfileSelectionStates(
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      children: children ?? this.children,
    );
  }

  @override
  List<Object?> get props => [selectedChildIndex, children];
}