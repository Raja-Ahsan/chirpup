// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/models/child_dashboard_model.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/repositories/child_dashboard_repository.dart';
import 'package:chirp_up_app/features/child/mood_selection/data/models/mood_items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'child_dashboard_events.dart';
import 'child_dashboard_states.dart';

class ChildDashboardBloc
    extends Bloc<ChildDashboardEvents, ChildDashboardStates> {
  final ChildDashboardRepository _repository = ChildDashboardRepository();

  ChildDashboardBloc()
    : super(
        const ChildDashboardStates(
          moods: [
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
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<SelectMoodEvent>(_onSelectMood);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<ChildDashboardStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final dashboardResponse = await _repository.getDashboard(event.childId);
      final moodResponse = await _repository.getTodayMood(event.childId);

      ChildDashboardModel? dashboardInfo;
      if (dashboardResponse['statusCode'] == 200 ||
          dashboardResponse['statusCode'] == 201) {
        dashboardInfo = ChildDashboardModel.fromJson(
          dashboardResponse['data'] ?? dashboardResponse,
        );
      }

      int? selectedIndex;
      if ((moodResponse['statusCode'] == 200 ||
              moodResponse['statusCode'] == 201) &&
          moodResponse['moodSubmitted'] == true) {
        final moodLabel = moodResponse['mood']?.toString().toLowerCase();
        final idx = state.moods.indexWhere(
          (m) => m.label.toLowerCase() == moodLabel,
        );
        selectedIndex = idx == -1 ? null : idx;
      }

      emit(
        state.copyWith(
          dashboardInfo: dashboardInfo,
          selectedMoodIndex: selectedIndex,
          clearMood: selectedIndex == null,
        ),
      );
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    }finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSelectMood(
    SelectMoodEvent event,
    Emitter<ChildDashboardStates> emit,
  ) async {
    final previousIndex = state.selectedMoodIndex;
    emit(state.copyWith(selectedMoodIndex: event.index));

    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _repository.updateMood(
        childId: event.childId,
        mood: state.moods[event.index].label.toLowerCase(),
        date: formattedDate,
      );

      if (!(response['statusCode'] == 200 || response['statusCode'] == 201)) {
        emit(
          state.copyWith(
            selectedMoodIndex: previousIndex,
            clearMood: previousIndex == null,
          ),
        );
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? response['message'] ?? "Mood Update Failed.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          selectedMoodIndex: previousIndex,
          clearMood: previousIndex == null,
        ),
      );
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    }
  }
}
