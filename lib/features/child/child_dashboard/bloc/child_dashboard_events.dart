import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChildDashboardEvents extends Equatable {
  const ChildDashboardEvents();
  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends ChildDashboardEvents {
  final BuildContext context;
  final String childId;
  const LoadDashboardEvent(this.context, this.childId);
  @override
  List<Object?> get props => [childId];
}

class SelectMoodEvent extends ChildDashboardEvents {
  final BuildContext context;
  final String childId;
  final int index;
  const SelectMoodEvent(this.context, this.childId, this.index);
  @override
  List<Object?> get props => [index];
}