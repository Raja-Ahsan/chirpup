// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_model.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/repositories/mood_selection_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_selection_events.dart';
import 'mood_selection_states.dart';

class MoodSelectionBloc extends Bloc<MoodSelectionEvents, MoodSelectionStates> {
  final MoodSelectionRepository _repository = MoodSelectionRepository();

  MoodSelectionBloc() : super(const MoodSelectionStates()) {
    on<MoodsRequested>(_onMoodsRequested);
    on<SelectMoodEvent>(_onSelectMood);
    on<SubmitMoodEvent>(_onSubmitMood);
  }

  Future<void> _onMoodsRequested(
    MoodsRequested event,
    Emitter<MoodSelectionStates> emit,
  ) async {
    emit(state.copyWith(isMoodsLoading: true));
    try {
      final response = await _repository.getMoods();

      if (response['code'] == 200 || response['code'] == 201) {
        final List<dynamic> rawList =
            (response['data']?['moods'] as List?) ?? [];
        final moods = rawList
            .map((e) => MoodModel.fromJson(e as Map<String, dynamic>))
            .where((m) => m.status == 'active')
            .toList();

        emit(state.copyWith(moods: moods, isMoodsLoading: false));
      } else {
        emit(state.copyWith(isMoodsLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isMoodsLoading: false));
    }
  }

  void _onSelectMood(SelectMoodEvent event, Emitter<MoodSelectionStates> emit) {
    emit(state.copyWith(selectedMoodIndex: event.index));
  }

  Future<void> _onSubmitMood(
    SubmitMoodEvent event,
    Emitter<MoodSelectionStates> emit,
  ) async {
    final mood = state.selectedMood;
    if (mood == null) {
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
        childSlug: event.childSlug,
        childId: event.childId,
        moodId: mood.id,
        date: formattedDate,
      );

      final bool ok =
          response is Map &&
          (response['success'] == true ||
              response['code'] == 200 ||
              response['code'] == 201);

      if (ok) {
        await event.onSuccess();
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            (response is Map
                    ? (response['error'] ?? response['message'])
                    : null)
                ?.toString() ??
                "Mood Selection Failed.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          e.toString().replaceFirst('Exception: ', ''),
        ),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
