import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_selection_events.dart';
import 'mood_selection_states.dart';

class MoodSelectionBloc extends Bloc<MoodSelectionEvents, MoodSelectionStates> {
  MoodSelectionBloc()
    : super(
        MoodSelectionStates(
          moods: const [
            MoodItem(
              label: 'Happy',
              imagePath: 'assets/png/happy_mood.png',
              bgColor: Color(0xffEFEAD4),
              selectedBgColor: Color(0xffF9C846),
            ),
            MoodItem(
              label: 'Calm',
              imagePath: 'assets/png/calm_mood.png',
              bgColor: Color(0xffD6E4F0),
              selectedBgColor: Color(0xff73B1F9),
            ),
            MoodItem(
              label: 'Sleepy',
              imagePath: 'assets/png/sleepy_mood.png',
              bgColor: Color(0xffD5E0F0),
              selectedBgColor: Color(0xff496DCD),
            ),
            MoodItem(
              label: 'Angry',
              imagePath: 'assets/png/angry_mood.png',
              bgColor: Color(0xffEEDFDF),
              selectedBgColor: Color(0xffF295A4),
            ),
            MoodItem(
              label: 'Sad',
              imagePath: 'assets/png/sad_mood.png',
              bgColor: Color(0xffD9E1E4),
              selectedBgColor: Color(0xffA5B6CD),
            ),
          ],
        ),
      ) {
    on<SelectMoodEvent>(_onSelectMood);
  }

  void _onSelectMood(SelectMoodEvent event, Emitter<MoodSelectionStates> emit) {
    emit(state.copyWith(selectedMoodIndex: event.index));
  }
}
