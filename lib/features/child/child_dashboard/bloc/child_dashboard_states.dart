import 'package:chirp_up_app/features/child/child_dashboard/data/models/child_dashboard_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:equatable/equatable.dart';

class ChildDashboardStates extends Equatable {
  final bool isLoading;
  final ChildDashboardModel? dashboardInfo;
  final int? selectedMoodIndex;
  final List<MoodItem> moods;

  const ChildDashboardStates({
    this.isLoading = true,
    this.dashboardInfo,
    this.selectedMoodIndex,
    this.moods = const [],
  });

  ChildDashboardStates copyWith({
    bool? isLoading,
    ChildDashboardModel? dashboardInfo,
    int? selectedMoodIndex,
    bool clearMood = false,
    List<MoodItem>? moods,
  }) {
    return ChildDashboardStates(
      isLoading: isLoading ?? this.isLoading,
      dashboardInfo: dashboardInfo ?? this.dashboardInfo,
      selectedMoodIndex:
          clearMood ? null : selectedMoodIndex ?? this.selectedMoodIndex,
      moods: moods ?? this.moods,
    );
  }

  MoodItem? get selectedMood =>
      selectedMoodIndex != null ? moods[selectedMoodIndex!] : null;

  @override
  List<Object?> get props =>
      [isLoading, dashboardInfo, selectedMoodIndex, moods];
}