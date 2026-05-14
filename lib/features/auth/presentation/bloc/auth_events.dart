import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthEvents extends Equatable {
  const AuthEvents();
  @override
  List<Object?> get props => [];
}

class SelectAvatarEvent extends AuthEvents {
  final int index;
  const SelectAvatarEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SelectAgeRangeEvent extends AuthEvents {
  final String ageRange;
  const SelectAgeRangeEvent(this.ageRange);

  @override
  List<Object?> get props => [ageRange];
}

class CreateYourChildProfileEvent extends AuthEvents {
  final BuildContext context;
  final String childName;
  const CreateYourChildProfileEvent({required this.childName, required this.context});

  @override
  List<Object?> get props => [childName];
}