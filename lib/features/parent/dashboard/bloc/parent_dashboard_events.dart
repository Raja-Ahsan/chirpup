import 'package:equatable/equatable.dart';

abstract class ParentDashboardEvents extends Equatable {
  const ParentDashboardEvents();
  @override
  List<Object?> get props => [];
}

class SelectChildEvent extends ParentDashboardEvents {
  final int index;
  const SelectChildEvent(this.index);

  @override
  List<Object?> get props => [index];
}