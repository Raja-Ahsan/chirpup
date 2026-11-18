import 'package:chirp_up_app/features/child/kingdom_workshop/data/models/game_model.dart';
import 'package:equatable/equatable.dart';

class KingdomWorkshopStates extends Equatable {
  final bool isLoading;
  final List<GameModel> games;

  const KingdomWorkshopStates({
    this.isLoading = true,
    this.games = const [],
  });

  KingdomWorkshopStates copyWith({bool? isLoading, List<GameModel>? games}) {
    return KingdomWorkshopStates(
      isLoading: isLoading ?? this.isLoading,
      games: games ?? this.games,
    );
  }

  @override
  List<Object?> get props => [isLoading, games];
} 