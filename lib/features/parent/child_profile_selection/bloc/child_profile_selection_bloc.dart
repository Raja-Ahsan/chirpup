// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/views/child_dashboard_view.dart';
import 'package:chirp_up_app/features/child/mood_selection/presentation/views/mood_selection_view.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_events.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_states.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/data/repositories/child_profile_selection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildProfileSelectionBloc
    extends Bloc<ChildProfileSelectionEvents, ChildProfileSelectionStates> {
  final ChildProfileSelectionRepository _repository =
      ChildProfileSelectionRepository();

  ChildProfileSelectionBloc() : super(const ChildProfileSelectionStates()) {
    on<FetchChildrenEvent>(_fetchChildren);
    on<SelectChildProfileEvent>(_selectChild);
    on<CheckPinStatusAndNavigateEvent>(_checkPinStatusAndNavigate);
    on<VerifyPinEvent>(_verifyPin);
  }

  Future<void> _fetchChildren(
    FetchChildrenEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
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

  Future<void> _checkPinStatusAndNavigate(
    CheckPinStatusAndNavigateEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    emit(state.copyWith(isPinLoading: true));
    try {
      final response = await _repository.checkPinStatus();

      emit(state.copyWith(isPinLoading: false));

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final bool hasPin = response['hasPin'] == true;

        if (hasPin) {
          Navigator.pushNamed(event.context, AppRoutes.enterPinCode);
        } else {
          final childId = state.selectedChild?.id ?? '';
          await _checkAndNavigateByMood(event.context, childId);
        }
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? response['message'] ?? "Something went wrong.",
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
      emit(state.copyWith(isPinLoading: false));
    }
  }

  Future<void> _verifyPin(
    VerifyPinEvent event,
    Emitter<ChildProfileSelectionStates> emit,
  ) async {
    if (event.pin.length < 4) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Please enter your full\nmagic code to continue.",
        ),
        barrierDismissible: true,
      );
      return;
    }

    emit(state.copyWith(isPinLoading: true));
    try {
      final response = await _repository.verifyPin(event.pin);
      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final childId = state.selectedChild?.id ?? '';
        await _checkAndNavigateByMood(event.context, childId);
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ??
                response['message'] ??
                "Incorrect PIN. Try again.",
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
      emit(state.copyWith(isPinLoading: false));
    }
  }

  Future<void> _checkAndNavigateByMood(
    BuildContext context,
    String childId,
  ) async {
    try {
      final response = await _repository.checkTodayMood(childId);

      if (response['moodSubmitted'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChildDashboardView(childId: childId),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MoodSelectionView(childId: childId),
          ),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MoodSelectionView(childId: childId),
        ),
      );
    }
  }
}
