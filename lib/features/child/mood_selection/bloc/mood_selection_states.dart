import 'package:chirp_up_app/features/child/mood_selection/data/games_data.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/game_item_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_model.dart';
import 'package:equatable/equatable.dart';

class MoodSelectionStates extends Equatable {
  final int? selectedMoodIndex;
  final List<MoodModel> moods;
  final bool isMoodsLoading;
  final bool isLoading;

  const MoodSelectionStates({
    this.selectedMoodIndex,
    this.moods = const [],
    this.isMoodsLoading = true,
    this.isLoading = false,
  });

  MoodSelectionStates copyWith({
    int? selectedMoodIndex,
    List<MoodModel>? moods,
    bool clearMood = false,
    bool? isMoodsLoading,
    bool? isLoading,
  }) {
    return MoodSelectionStates(
      selectedMoodIndex: clearMood
          ? null
          : selectedMoodIndex ?? this.selectedMoodIndex,
      moods: moods ?? this.moods,
      isMoodsLoading: isMoodsLoading ?? this.isMoodsLoading,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  MoodModel? get selectedMood =>
      (selectedMoodIndex != null &&
          selectedMoodIndex! >= 0 &&
          selectedMoodIndex! < moods.length)
      ? moods[selectedMoodIndex!]
      : null;

  List<GameItem> get suggestedGames =>
      selectedMood != null ? GamesData.gamesForMood(selectedMood!.name) : [];

  @override
  List<Object?> get props =>
      [selectedMoodIndex, moods, isMoodsLoading, isLoading];
}
