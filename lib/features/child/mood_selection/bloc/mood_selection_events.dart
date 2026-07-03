import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MoodSelectionEvents extends Equatable {
  const MoodSelectionEvents();
  @override
  List<Object?> get props => [];
}

class SelectMoodEvent extends MoodSelectionEvents {
  final int index;
  const SelectMoodEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class SubmitMoodEvent extends MoodSelectionEvents {
  final String childId;
  final BuildContext context;
  final Future<void> Function() onSuccess;
  const SubmitMoodEvent(this.context, this.childId, this.onSuccess);
  @override
  List<Object?> get props => [context, childId];
}