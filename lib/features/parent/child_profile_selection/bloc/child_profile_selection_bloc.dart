// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/views/child_dashboard_view.dart';
import 'package:chirp_up_app/features/child/mood_selection/presentation/views/mood_selection_view.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_events.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_states.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/data/repositories/child_profile_selection_repository.dart';
import 'package:chirp_up_app/features/parent/dashboard/data/models/all_children_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildProfileSelectionBloc
    extends Bloc<ChildProfileSelectionEvents, ChildProfileSelectionStates> {
  final ChildProfileSelectionRepository _repository =
      ChildProfileSelectionRepository();

  ChildProfileSelectionBloc() : super(const ChildProfileSelectionStates()) {
    on<FetchChildrenEvent>(_fetchChildren);
    on<SelectChildProfileEvent>(_selectChild);
    on<EnterKingdomEvent>(_enterKingdom);
    on<VerifyPinEvent>(_verifyPin);
  }

  Future<void> _fetchChildren(
    FetchChildrenEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repository.fetchChildren();
      emit(
        state.copyWith(
          isLoading: false,
          children: result.children,
          selectedChildIndex: 0,
        ),
      );
    } catch (e) {
      print(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _selectChild(
    SelectChildProfileEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) {
    emit(state.copyWith(selectedChildIndex: event.index));
  }

  /// hasPin true -> pin screen, false -> seedha mood/dashboard
  Future<void> _enterKingdom(
    EnterKingdomEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    final child = state.selectedChild;
    if (child == null) return;

    if (child.hasPin) {
      Navigator.pushNamed(event.context, AppRoutes.enterPinCode);
    } else {
      await _openChild(event.context, child);
    }
  }

  Future<void> _verifyPin(
    VerifyPinEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    if (event.pin.length < 4) {
      _showError(event.context, "Please enter your full\nmagic code to continue.");
      return;
    }

    final child = state.selectedChild;
    if (child == null) return;

    emit(state.copyWith(isPinLoading: true));
    try {
      final response = await _repository.verifyPin(event.pin);

      final bool verified =
          response is Map &&
          response['success'] == true &&
          response['data'] is Map &&
          response['data']['verified'] == true;

      if (verified) {
        await _openChild(event.context, child);
      } else {
        _showError(
          event.context,
          (response is Map ? response['message'] : null)?.toString() ??
              "The parent pin is incorrect.",
        );
      }
    } catch (e) {
      _showError(event.context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      emit(state.copyWith(isPinLoading: false));
    }
  }

  Future<void> _openChild(BuildContext context, Child child) async {
    final childId = child.id?.toString() ?? '';
    await StorageService.setChildId(childId);

    final Widget screen = child.todayMood == null
        ? MoodSelectionView(childId: childId, childSlug: child.slug ?? '')
        : ChildDashboardView(childId: childId, childSlug: child.slug ?? '');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _showError(BuildContext context, String message) {
    showCommonDialog(
      context: context,
      child: errorDialog(context, message),
      barrierDismissible: true,
    );
  }
}