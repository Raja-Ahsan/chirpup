import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(AuthStates()) {
    on<SelectAvatarEvent>(_selectAvatar);
    on<SelectAgeRangeEvent>(_selectAgeRange);
    on<CreateYourChildProfileEvent>(_createYourChildProfile);
    on<EnterPinEvent>(_enterPin);
    on<ConfirmPinEvent>(_confirmPin);
  }

  void _selectAvatar(SelectAvatarEvent event, Emitter<AuthStates> emit) {
    emit(state.copyWith(selectedAvatarIndex: event.index));
  }

  void _selectAgeRange(SelectAgeRangeEvent event, Emitter<AuthStates> emit) {
    emit(state.copyWith(selectedAgeRange: event.ageRange));
  }

  void _createYourChildProfile(
    CreateYourChildProfileEvent event,
    Emitter<AuthStates> emit,
  ) {
    if (event.childName.trim().isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter your\nchild’s name"),
        barrierDismissible: true,
        rightPadding: 10,
        topPadding: 10,
      );
      return;
    }

    if (state.selectedAgeRange.isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Please select your\nchild’s age range",
        ),
        barrierDismissible: true,
        rightPadding: 10,
        topPadding: 10,
      );
      return;
    }
    emit(state.copyWith(childName: event.childName));
    Navigator.pushNamed(event.context, AppRoutes.kingdomIsReady);
  }

  void _enterPin(EnterPinEvent event, Emitter<AuthStates> emit) {
    debugPrint('enter_pin: ${event.pin}');
    emit(state.copyWith(enteredPin: event.pin));
    Navigator.pushNamed(event.context, AppRoutes.setupYourPin, arguments: true);
    // arguments: true = isConfirmMode, route same hai bas bool pass ho raha
  }

  void _confirmPin(ConfirmPinEvent event, Emitter<AuthStates> emit) {
    debugPrint('confirm_pin: ${event.confirmPin}');

    if (event.confirmPin != state.enteredPin) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Looks like the PINs don’t match.\nPlease try again."),
        barrierDismissible: true,
        rightPadding: 10,
        topPadding: 10,
      );
      return;
    }

    // ✅ PIN match hua — agle route pe navigate karo
    Navigator.pushNamed(event.context, AppRoutes.tapOnCastle);
  }
}
