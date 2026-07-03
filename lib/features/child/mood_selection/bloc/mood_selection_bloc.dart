// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/repositories/mood_selection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_selection_events.dart';
import 'mood_selection_states.dart';

class MoodSelectionBloc extends Bloc<MoodSelectionEvents, MoodSelectionStates> {
  final MoodSelectionRepository _repository = MoodSelectionRepository();

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
    on<SubmitMoodEvent>(_onSubmitMood);
  }

  void _onSelectMood(SelectMoodEvent event, Emitter<MoodSelectionStates> emit) {
    emit(state.copyWith(selectedMoodIndex: event.index));
  }

  Future<void> _onSubmitMood(
    SubmitMoodEvent event,
    Emitter<MoodSelectionStates> emit,
  ) async {
    if (state.selectedMood == null) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please Select\nMood."),
        barrierDismissible: true,
      );
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _repository.submitMood(
        childId: event.childId,
        mood: state.selectedMood!.label.toLowerCase(),
        date: formattedDate,
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        await event.onSuccess();
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ??
                response['message'] ??
                "Mood Selection Failed.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
