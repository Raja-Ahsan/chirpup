import 'package:flutter_bloc/flutter_bloc.dart';
import 'child_profile_selection_events.dart';
import 'child_profile_selection_states.dart';

class ChildProfileSelectionBloc
    extends Bloc<ChildProfileSelectionEvents, ChildProfileSelectionStates> {
  ChildProfileSelectionBloc() : super(const ChildProfileSelectionStates()) {
    on<InitChildSelectionEvent>((event, emit) {
      emit(
        state.copyWith(
          children: event.children,
          selectedChildIndex: event.selectedIndex,
        ),
      );
    });

    on<SelectChildProfileEvent>((event, emit) {
      emit(state.copyWith(selectedChildIndex: event.index));
    });
  }
}
