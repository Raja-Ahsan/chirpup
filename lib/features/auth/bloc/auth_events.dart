import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthEvents extends Equatable {
  const AuthEvents();
  @override
  List<Object?> get props => [];
}

class CharactersRequested extends AuthEvents {
  const CharactersRequested();
}

class YearsRequested extends AuthEvents {
  const YearsRequested();
}

class SelectAgeRangeEvent extends AuthEvents {
  final String yearIndex;
  const SelectAgeRangeEvent(this.yearIndex);

  @override
  List<Object?> get props => [yearIndex];
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
  const CreateYourChildProfileEvent({
    required this.childName,
    required this.context,
  });

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

class SetupPinEvent extends AuthEvents {
  final BuildContext context;
  final String pin;
  const SetupPinEvent({required this.context, required this.pin});

  @override
  List<Object?> get props => [pin];
}

class RegisterEvent extends AuthEvents {
  final BuildContext context;
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}

class VerifyOtpEvent extends AuthEvents {
  final BuildContext context;
  final String email;
  final String otp;

  const VerifyOtpEvent({
    required this.context,
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvents {
  final BuildContext context;
  final String email;

  const ResendOtpEvent({required this.context, required this.email});

  @override
  List<Object?> get props => [email];
}

class LoginEvent extends AuthEvents {
  final BuildContext context;
  final String email;
  final String password;

  const LoginEvent({
    required this.context,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}