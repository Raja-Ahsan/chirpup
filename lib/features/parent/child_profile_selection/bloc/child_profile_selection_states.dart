import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:equatable/equatable.dart';

class ChildProfileSelectionStates extends Equatable {
  final int selectedChildIndex;
  final List<Child> children;
  final bool isLoading;
  final bool isPinLoading;

  const ChildProfileSelectionStates({
    this.selectedChildIndex = 0,
    this.children = const [],
    this.isLoading = false,
    this.isPinLoading = false,
  });

  Child? get selectedChild =>
      children.isEmpty ? null : children[selectedChildIndex];

  ChildProfileSelectionStates copyWith({
    int? selectedChildIndex,
    List<Child>? children,
    bool? isLoading,
    bool? isPinLoading,
  }) {
    return ChildProfileSelectionStates(
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
      isPinLoading: isPinLoading ?? this.isPinLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedChildIndex,
    children,
    isLoading,
    isPinLoading,
  ];
}