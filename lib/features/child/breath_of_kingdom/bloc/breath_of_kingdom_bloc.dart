import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_events.dart';
import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreathOfKingdomBloc
    extends Bloc<BreathOfKingdomEvents, BreathOfKingdomStates> {
  BreathOfKingdomBloc() : super(BreathOfKingdomStates()) {
    on<SelectCharacterEvent>(_selectCharacter);
  }
  void _selectCharacter(
    SelectCharacterEvent event,
    Emitter<BreathOfKingdomStates> emit,
  ) {
    emit(state.copyWith(selectedCharacterIndex: event.index));
  }
}
