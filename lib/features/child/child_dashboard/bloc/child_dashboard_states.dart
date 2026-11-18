import 'package:chirp_up_app/features/child/child_dashboard/data/models/child_dashboard_model.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/models/game_category_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:equatable/equatable.dart';

class ChildDashboardStates extends Equatable {
  final bool isLoading;
  final ChildDashboardModel? dashboardInfo;
  final int? selectedMoodIndex;
  final List<MoodItem> moods;
  final Map<String, int> moodIds;
  final List<GameCategoryModel> gameCategories;

  const ChildDashboardStates({
    this.isLoading = true,
    this.dashboardInfo,
    this.selectedMoodIndex,
    this.moods = const [],
    this.moodIds = const {},
    this.gameCategories = const [],
  });

  ChildDashboardStates copyWith({
    bool? isLoading,
    ChildDashboardModel? dashboardInfo,
    int? selectedMoodIndex,
    bool clearMood = false,
    List<MoodItem>? moods,
    Map<String, int>? moodIds,
    List<GameCategoryModel>? gameCategories,
  }) {
    return ChildDashboardStates(
      isLoading: isLoading ?? this.isLoading,
      dashboardInfo: dashboardInfo ?? this.dashboardInfo,
      selectedMoodIndex: clearMood
          ? null
          : selectedMoodIndex ?? this.selectedMoodIndex,
      moods: moods ?? this.moods,
      moodIds: moodIds ?? this.moodIds,
      gameCategories: gameCategories ?? this.gameCategories,
    );
  }

  MoodItem? get selectedMood =>
      selectedMoodIndex != null ? moods[selectedMoodIndex!] : null;

  @override
  List<Object?> get props => [
    isLoading,
    dashboardInfo,
    selectedMoodIndex,
    moods,
    moodIds,
    gameCategories,
  ];
}