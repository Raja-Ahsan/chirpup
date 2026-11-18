import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_events.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_states.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/child_detail_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/game_categories_model.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/repositories/parent_dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentDashboardBloc
    extends Bloc<ParentDashboardEvents, ParentDashboardStates> {
  final ParentDashboardRepository _repository = ParentDashboardRepository();

  ParentDashboardBloc() : super(const ParentDashboardStates()) {
    on<FetchChildrenEvent>(_fetchChildren);
    on<SelectChildEvent>(_selectChild);
  }

  bool _isCurrent(String slug) =>
      state.children.isNotEmpty &&
      state.selectedChildIndex < state.children.length &&
      state.children[state.selectedChildIndex].slug == slug;

  Future<ChildDetailModel?> _safeDetail(String slug) async {
    try {
      return await _repository.fetchChildDetail(slug);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<GameCategoriesModel?> _safeCategories() async {
    try {
      return await _repository.fetchGameCategories();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> _loadChildData(
    String slug,
    Emitter<ParentDashboardStates> emit,
  ) async {
    final results = await Future.wait([_safeDetail(slug), _safeCategories()]);

    if (!_isCurrent(slug)) return;

    final detail = results[0] as ChildDetailModel?;
    final categories = results[1] as GameCategoriesModel?;

    emit(
      state.copyWith(
        childDetail: detail?.child,
        categories: categories?.categories,
      ),
    );
  }

  Future<void> _fetchChildren(
    FetchChildrenEvent event,
    Emitter<ParentDashboardStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repository.fetchChildren();
      final children = result.children;
      emit(
        state.copyWith(
          isLoading: true,
          children: children,
          selectedChildIndex: 0,
        ),
      );

      if (children.isNotEmpty) {
        await _loadChildData(children[0].slug ?? '', emit);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _selectChild(
    SelectChildEvent event,
    Emitter<ParentDashboardStates> emit,
  ) async {
    emit(state.copyWith(selectedChildIndex: event.index, isStatsLoading: true));

    await _loadChildData(event.childSlug, emit);

    // Sirf latest selected child hi loading band kare
    if (_isCurrent(event.childSlug)) {
      emit(state.copyWith(isStatsLoading: false));
    }
  }
}
