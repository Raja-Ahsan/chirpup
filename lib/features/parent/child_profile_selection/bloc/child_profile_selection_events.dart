import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChildProfileSelectionEvents extends Equatable {
  const ChildProfileSelectionEvents();
  @override
  List<Object?> get props => [];
}

class FetchChildrenEvent extends ChildProfileSelectionEvents {
  const FetchChildrenEvent();
}

class SelectChildProfileEvent extends ChildProfileSelectionEvents {
  final int index;
  const SelectChildProfileEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class CheckPinStatusAndNavigateEvent extends ChildProfileSelectionEvents {
  final BuildContext context;
  const CheckPinStatusAndNavigateEvent({required this.context});
}

class VerifyPinEvent extends ChildProfileSelectionEvents {
  final BuildContext context;
  final String pin;
  const VerifyPinEvent({required this.context, required this.pin});
  @override
  List<Object?> get props => [pin];
}