import 'package:equatable/equatable.dart';

class ChildModel {
  final String name;
  final String ageRange;
  final String imagePath;

  const ChildModel({
    required this.name,
    required this.ageRange,
    required this.imagePath,
  });
}

class ParentDashboardStates extends Equatable {
  final int selectedChildIndex;
  final List<ChildModel> children;

  const ParentDashboardStates({
    this.selectedChildIndex = 0,
    this.children = const [],
  });

  ParentDashboardStates copyWith({
    int? selectedChildIndex,
    List<ChildModel>? children,
  }) {
    return ParentDashboardStates(
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      children: children ?? this.children,
    );
  }

  @override
  List<Object?> get props => [selectedChildIndex, children];
}