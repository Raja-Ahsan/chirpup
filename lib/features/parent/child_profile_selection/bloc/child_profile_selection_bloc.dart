import 'package:chirp_up_app/features/parent/dashboard/data/models/child_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'child_profile_selection_events.dart';
import 'child_profile_selection_states.dart';

class ChildProfileSelectionBloc
    extends Bloc<ChildProfileSelectionEvents, ChildProfileSelectionStates> {
  ChildProfileSelectionBloc()
    : super(
        ChildProfileSelectionStates(
          selectedChildIndex: 0,
          children: [
            ChildModel(
              name: 'Jason',
              ageRange: '7-8 Years',
              imagePath: 'assets/png/prince_character.png',
            ),
            ChildModel(
              name: 'Ana',
              ageRange: '5-6 Years',
              imagePath: 'assets/png/princes_character.png',
            ),
            ChildModel(
              name: 'Alex',
              ageRange: '9-10 Years',
              imagePath: 'assets/png/knight_character.png',
            ),
          ],
        ),
      ) {
    on<SelectChildProfileEvent>((event, emit) {
      emit(state.copyWith(selectedChildIndex: event.index));
    });
  }
}
