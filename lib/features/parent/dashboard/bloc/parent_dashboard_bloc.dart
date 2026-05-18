import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_events.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentDashboardBloc
    extends Bloc<ParentDashboardEvents, ParentDashboardStates> {
  ParentDashboardBloc()
    : super(
        // ✅ dummy data — baad mein API se replace karna
        ParentDashboardStates(
          selectedChildIndex: 1,
          children: [
            ChildModel(
              name: 'Emna',
              ageRange: '5-6 Years',
              imagePath: 'assets/png/girl_character_1.png',
            ),
            ChildModel(
              name: 'Jason',
              ageRange: '7-8 Years',
              imagePath: 'assets/png/boy_character_1.png',
            ),
            ChildModel(
              name: 'Alex',
              ageRange: '9-10 Years',
              imagePath: 'assets/png/girl_character_2.png',
            ),
          ],
        ),
      ) {
    on<SelectChildEvent>(_selectChild);
  }

  void _selectChild(SelectChildEvent event,Emitter<ParentDashboardStates> emit) {
    emit(state.copyWith(selectedChildIndex: event.index));
  }
}
