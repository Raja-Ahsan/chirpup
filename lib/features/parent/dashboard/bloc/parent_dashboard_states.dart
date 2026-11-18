import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/game_categories_model.dart';
import 'package:equatable/equatable.dart';

class ParentDashboardStates extends Equatable {
  final int selectedChildIndex;
  final List<Child> children;
  final Child? childDetail;
  final List<GameCategory> categories;
  final bool isLoading;
  final bool isStatsLoading;

  const ParentDashboardStates({
    this.selectedChildIndex = 0,
    this.children = const [],
    this.childDetail,
    this.categories = const [],
    this.isLoading = false,
    this.isStatsLoading = false,
  });

  ParentDashboardStates copyWith({
    int? selectedChildIndex,
    List<Child>? children,
    Child? childDetail,
    List<GameCategory>? categories,
    bool? isLoading,
    bool? isStatsLoading,
  }) {
    return ParentDashboardStates(
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      children: children ?? this.children,
      childDetail: childDetail ?? this.childDetail,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isStatsLoading: isStatsLoading ?? this.isStatsLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedChildIndex,
    children,
    childDetail,
    categories,
    isLoading,
    isStatsLoading,
  ];
}
