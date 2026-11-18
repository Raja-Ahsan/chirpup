import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class KingdomWorkshopEvents extends Equatable {
  const KingdomWorkshopEvents();
  @override
  List<Object?> get props => [];
}

class LoadGamesEvent extends KingdomWorkshopEvents {
  final BuildContext context;
  final int gameCategoryId;
  final int? yearId;
  const LoadGamesEvent(this.context, this.gameCategoryId, this.yearId);
  @override
  List<Object?> get props => [gameCategoryId, yearId];
}