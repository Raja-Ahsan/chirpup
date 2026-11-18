import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChildDashboardEvents extends Equatable {
  const ChildDashboardEvents();
  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends ChildDashboardEvents {
  final BuildContext context;
  final String childSlug;
  const LoadDashboardEvent(this.context, this.childSlug);
  @override
  List<Object?> get props => [childSlug];
}

class SelectMoodEvent extends ChildDashboardEvents {
  final BuildContext context;
  final String childSlug;
  final String childId;
  final int index;
  const SelectMoodEvent(this.context, this.childSlug, this.childId, this.index);
  @override
  List<Object?> get props => [childSlug, childId, index];
}