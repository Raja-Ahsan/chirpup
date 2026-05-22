import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:equatable/equatable.dart';

class MoodSelectionStates extends Equatable {
  final int? selectedMoodIndex;
  final List<MoodItem> moods;

  const MoodSelectionStates({this.selectedMoodIndex, this.moods = const []});

  MoodSelectionStates copyWith({
    int? selectedMoodIndex,
    List<MoodItem>? moods,
    bool clearMood = false,
  }) {
    return MoodSelectionStates(
      selectedMoodIndex: clearMood
          ? null
          : selectedMoodIndex ?? this.selectedMoodIndex,
      moods: moods ?? this.moods,
    );
  }

  MoodItem? get selectedMood =>
      selectedMoodIndex != null ? moods[selectedMoodIndex!] : null;

  @override
  List<Object?> get props => [selectedMoodIndex, moods];
}
