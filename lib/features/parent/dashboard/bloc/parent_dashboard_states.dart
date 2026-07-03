import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/child_week_status_model.dart';
import 'package:equatable/equatable.dart';

class ParentDashboardStates extends Equatable {
  final int selectedChildIndex;
  final List<Child> children;
  final ChildWeekStatusModel? weeklyStats;
  final bool isLoading;
  final bool isStatsLoading;

  const ParentDashboardStates({
    this.selectedChildIndex = 0,
    this.children = const [],
    this.weeklyStats,
    this.isLoading = false,
    this.isStatsLoading = false,
  });

  ParentDashboardStates copyWith({
    int? selectedChildIndex,
    List<Child>? children,
    ChildWeekStatusModel? weeklyStats,
    bool? isLoading,
    bool? isStatsLoading,
  }) {
    return ParentDashboardStates(
      selectedChildIndex: selectedChildIndex ?? this.selectedChildIndex,
      children: children ?? this.children,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      isLoading: isLoading ?? this.isLoading,
      isStatsLoading: isStatsLoading ?? this.isStatsLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedChildIndex,
    children,
    weeklyStats,
    isLoading,
    isStatsLoading,
  ];
}
