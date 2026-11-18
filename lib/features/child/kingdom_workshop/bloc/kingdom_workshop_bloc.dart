// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/bloc/kingdom_workshop_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/bloc/kingdom_workshop_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/data/models/game_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/data/repositories/kingdom_workshop_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KingdomWorkshopBloc
    extends Bloc<KingdomWorkshopEvents, KingdomWorkshopStates> {
  final KingdomWorkshopRepository _repository = KingdomWorkshopRepository();

  KingdomWorkshopBloc() : super(const KingdomWorkshopStates()) {
    on<LoadGamesEvent>(_onLoadGames);
  }

  Future<void> _onLoadGames(
    LoadGamesEvent event,
    Emitter<KingdomWorkshopStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final dynamic response = await _repository.getGames(
        gameCategoryId: event.gameCategoryId,
        yearId: event.yearId,
      );

      dynamic data;
      if (response is Map && response['success'] == true) {
        data = response['data'];
      }

      if (data is! List) {
        final dynamic msg = response is Map ? response['message'] : null;
        throw Exception(msg?.toString() ?? 'Could not load games.');
      }

      final games = data
          .whereType<Map>()
          .map((e) => GameModel.fromJson(Map<String, dynamic>.from(e)))
          .where((g) => g.status == 'active')
          .toList();

      emit(state.copyWith(games: games));
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
}
