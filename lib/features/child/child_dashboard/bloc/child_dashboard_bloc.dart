// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/models/child_dashboard_model.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/models/game_category_model.dart';
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

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // /moods se slug -> id map. Fail ho to khali map, kabhi throw nahi karta
  Future<Map<String, int>> _fetchMoodIds() async {
    try {
      final response = await _repository.getMoods();
      final list = (response['data']?['moods'] as List?) ?? [];
      final map = <String, int>{};
      for (final m in list) {
        if (m is Map && m['slug'] != null && m['id'] != null) {
          final id = m['id'] is int
              ? m['id'] as int
              : int.tryParse('${m['id']}');
          if (id != null) map[m['slug'].toString().toLowerCase()] = id;
        }
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  // Fail ho to khali list, dashboard kabhi nahi rukta
Future<List<GameCategoryModel>> _fetchGameCategories() async {
    try {
      final response = await _repository.getGameCategories();
      final list = (response['data']?['categories'] as List?) ?? [];
      return list
          .whereType<Map>()
          .map((e) => GameCategoryModel.fromJson(Map<String, dynamic>.from(e)))
          .where((c) => c.status == 'active')
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<ChildDashboardStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait<dynamic>([
        _repository.getChild(event.childSlug),
        _fetchMoodIds(),
        _fetchGameCategories(),
      ]);
      final dynamic childResponse = results[0];
      final Map<String, int> moodIds = results[1] as Map<String, int>;
      final List<GameCategoryModel> gameCategories = results[2] as List<GameCategoryModel>;

      // ternary hata kar simple if, taake parser confuse na ho
      dynamic childJson;
      if (childResponse is Map && childResponse['success'] == true) {
        final dynamic data = childResponse['data'];
        if (data is Map) {
          childJson = data['child'];
        }
      }

      if (childJson is! Map) {
        final dynamic msg = childResponse is Map
            ? childResponse['message']
            : null;
        throw Exception(msg?.toString() ?? 'Could not load dashboard.');
      }

      final info = ChildDashboardModel.fromJson(
        Map<String, dynamic>.from(childJson),
      );

      // sirf aaj ka mood select dikhao: today_mood ho AUR mood_date aaj ki ho
      int? selectedIndex;
      if (info.todayMoodId != null && info.moodDate == _today()) {
        String? slug;
        for (final e in moodIds.entries) {
          if (e.value == info.todayMoodId) {
            slug = e.key;
            break;
          }
        }
        slug ??= info.todayMoodSlug;

        if (slug != null) {
          final idx = state.moods.indexWhere(
            (m) => m.label.toLowerCase() == slug,
          );
          selectedIndex = idx == -1 ? null : idx;
        }
      }

      emit(
        state.copyWith(
          dashboardInfo: info,
          moodIds: moodIds,
          gameCategories: gameCategories,
          selectedMoodIndex: selectedIndex,
          clearMood: selectedIndex == null,
        ),
      );
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

  Future<void> _onSelectMood(
    SelectMoodEvent event,
    Emitter<ChildDashboardStates> emit,
  ) async {
    final previousIndex = state.selectedMoodIndex;
    final slug = state.moods[event.index].label.toLowerCase();
    final moodId = state.moodIds[slug];

    if (moodId == null) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          'Could not update mood.\nPlease try again.',
        ),
        barrierDismissible: true,
      );
      return;
    }

    emit(state.copyWith(selectedMoodIndex: event.index));

    try {
      final response = await _repository.updateMood(
        childSlug: event.childSlug,
        childId: event.childId,
        moodId: moodId,
        date: _today(),
      );

      final bool ok =
          response is Map &&
          (response['success'] == true ||
              response['code'] == 200 ||
              response['code'] == 201);

      if (!ok) {
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
            ((response is Map
                        ? (response['error'] ?? response['message'])
                        : null) ??
                    'Mood Update Failed.')
                .toString(),
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
        child: errorDialog(
          event.context,
          e.toString().replaceFirst('Exception: ', ''),
        ),
        barrierDismissible: true,
      );
    }
  }
}
