import 'package:chirp_up_app/features/child/mood_selection/data/games_data.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/game_item_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:equatable/equatable.dart';

class MoodSelectionStates extends Equatable {
  final int? selectedMoodIndex;
  final List<MoodItem> moods;
  final bool isLoading;

  const MoodSelectionStates({this.selectedMoodIndex, this.moods = const [],this.isLoading = false,});

  MoodSelectionStates copyWith({
    int? selectedMoodIndex,
    List<MoodItem>? moods,
    bool clearMood = false,
    bool? isLoading,
  }) {
    return MoodSelectionStates(
      selectedMoodIndex: clearMood
          ? null
          : selectedMoodIndex ?? this.selectedMoodIndex,
      moods: moods ?? this.moods,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  MoodItem? get selectedMood =>
      selectedMoodIndex != null ? moods[selectedMoodIndex!] : null;

  List<GameItem> get suggestedGames =>
      selectedMood != null ? GamesData.gamesForMood(selectedMood!.label) : [];

  @override
  List<Object?> get props => [selectedMoodIndex, moods, isLoading];
}
