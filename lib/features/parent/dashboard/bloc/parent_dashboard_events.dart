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
  final String childSlug;
  const SelectChildEvent(this.index, this.childSlug);

  @override
  List<Object?> get props => [index, childSlug];
}