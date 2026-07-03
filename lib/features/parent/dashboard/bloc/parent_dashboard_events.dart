import 'package:equatable/equatable.dart';

abstract class ParentDashboardEvents extends Equatable {
  const ParentDashboardEvents();
  @override
  List<Object?> get props => [];
}

class FetchChildrenEvent extends ParentDashboardEvents {
  const FetchChildrenEvent();
}

class SelectChildEvent extends ParentDashboardEvents {
  final int index;
  final String childId;
  const SelectChildEvent(this.index, this.childId);

  @override
  List<Object?> get props => [index, childId];
}

class FetchChildWeeklyStatsEvent extends ParentDashboardEvents {
  final String childId;
  const FetchChildWeeklyStatsEvent(this.childId);

  @override
  List<Object?> get props => [childId];
}