import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_events.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_states.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/repositories/parent_dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentDashboardBloc
    extends Bloc<ParentDashboardEvents, ParentDashboardStates> {
  final ParentDashboardRepository _repository = ParentDashboardRepository();

  ParentDashboardBloc() : super(const ParentDashboardStates()) {
    on<FetchChildrenEvent>(_fetchChildren);
    on<SelectChildEvent>(_selectChild);
    on<FetchChildWeeklyStatsEvent>(_fetchChildWeeklyStats);
  }

  Future<void> _fetchChildren(
    FetchChildrenEvent event,
    Emitter<ParentDashboardStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repository.fetchChildren();
      final children = result.children;

      emit(state.copyWith(isLoading: false, children: children));
      if (children.isNotEmpty) {
        add(FetchChildWeeklyStatsEvent(children[0].id ?? ''));
      }
    } catch (e) {
      print(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _selectChild(
    SelectChildEvent event,
    Emitter<ParentDashboardStates> emit,
  ) {
    emit(state.copyWith(selectedChildIndex: event.index));
    add(FetchChildWeeklyStatsEvent(event.childId));
  }

  Future<void> _fetchChildWeeklyStats(
    FetchChildWeeklyStatsEvent event,
    Emitter<ParentDashboardStates> emit,
  ) async {
    emit(state.copyWith(isStatsLoading: true));
    try {
      final stats = await _repository.fetchChildWeeklyStats(event.childId);
      emit(state.copyWith(weeklyStats: stats));
    } catch (e) {
      print(e.toString());
    } finally {
      emit(state.copyWith(isStatsLoading: false));
    }
  }
}
