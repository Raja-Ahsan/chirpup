import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthEvents extends Equatable {
  const AuthEvents();
  @override
  List<Object?> get props => [];
}

class SelectAgeRangeEvent extends AuthEvents {
  final String ageRange;
  const SelectAgeRangeEvent(this.ageRange);

  @override
  List<Object?> get props => [ageRange];
}

class SelectCharacterEvent extends AuthEvents {
  final int index;
  const SelectCharacterEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class CreateYourChildProfileEvent extends AuthEvents {
  final BuildContext context;
  final String childName;
  const CreateYourChildProfileEvent({required this.childName, required this.context});

  @override
  List<Object?> get props => [childName];
}

class EnterPinEvent extends AuthEvents {
  final BuildContext context;
  final String pin;
  const EnterPinEvent({required this.context, required this.pin});

  @override
  List<Object?> get props => [pin];
}

class ConfirmPinEvent extends AuthEvents {
  final BuildContext context;
  final String confirmPin;
  const ConfirmPinEvent({required this.context, required this.confirmPin});

  @override
  List<Object?> get props => [confirmPin];
}