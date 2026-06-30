// ignore_for_file: use_build_context_synchronously
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/core/utils/flushbar_helper.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/error_dialog.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:chirp_up_app/features/auth/data/repositories/auth_repository.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/account_verified_dialog.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/otp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final AuthRepository _authRepository = AuthRepository();
  AuthBloc() : super(AuthStates()) {
    on<SelectCharacterEvent>(_selectCharacter);
    on<SelectAgeRangeEvent>(_selectAgeRange);
    on<CreateYourChildProfileEvent>(_createYourChildProfile);
    on<EnterPinEvent>(_enterPin);
    on<SetupPinEvent>(_setupPin);
    on<SkipPinEvent>(_skipPin);
    on<RegisterEvent>(_register);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<LoginEvent>(_login);
  }

  void _selectCharacter(SelectCharacterEvent event, Emitter<AuthStates> emit) {
    emit(state.copyWith(selectedCharacterIndex: event.index));
  }

  void _selectAgeRange(SelectAgeRangeEvent event, Emitter<AuthStates> emit) {
    emit(state.copyWith(selectedAgeRange: event.ageRange));
  }

  Future<void> _createYourChildProfile(
    CreateYourChildProfileEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if (event.childName.trim().isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter your\nchild's name"),
        barrierDismissible: true,
      );
      return;
    }

    if (state.selectedAgeRange.isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Please select your\nchild's age range",
        ),
        barrierDismissible: true,
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.createChildProfile({
        "characterId": state.selectedCharacter.id,
        "name": event.childName.trim(),
        "age": state.selectedAgeRange,
      });

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        emit(state.copyWith(childName: event.childName.trim(),selectedAgeRange: '',));
        Navigator.pushNamed(event.context, AppRoutes.kingdomIsReady);
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ??
                response['message'] ??
                "Could not create profile.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _enterPin(EnterPinEvent event, Emitter<AuthStates> emit) {
    debugPrint('enter_pin: ${event.pin}');
    if (event.pin.trim().isEmpty || event.pin.length < 4) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter a\n4-digit PIN"),
        barrierDismissible: true,
      );
      return;
    }
    emit(state.copyWith(enteredPin: event.pin));
    Navigator.pushNamed(event.context, AppRoutes.setupYourPin, arguments: true);
    // arguments: true = isConfirmMode, route same hai bas bool pass ho raha
  }

  Future<void> _setupPin(SetupPinEvent event, Emitter<AuthStates> emit) async {
    if (event.pin.trim().isEmpty || event.pin.length < 4) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter a\n4-digit PIN"),
        barrierDismissible: true,
      );
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final response = await _authRepository.setupPin({"pin": event.pin});

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        Navigator.pushNamedAndRemoveUntil(
          event.context,
          AppRoutes.tapOnCastle,
          (route) => false,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? response['message'] ?? "Could not set PIN.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _skipPin(SkipPinEvent event, Emitter<AuthStates> emit) async {
    emit(state.copyWith(isSkipPin: true));
    try {
      final response = await _authRepository.skipPin();

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        Navigator.pushNamedAndRemoveUntil(
          event.context,
          AppRoutes.tapOnCastle,
          (route) => false,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? response['message'] ?? "Could not skip PIN.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isSkipPin: false));
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthStates> emit) async {
    if (event.fullName.trim().isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter your full name"),
        barrierDismissible: true,
      );
      return;
    }

    if (event.email.trim().isEmpty ||
        !RegExp(
          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(event.email.trim())) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter a valid email"),
        barrierDismissible: true,
      );
      return;
    }

    if (event.password.length < 8) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Password must be at least 8 characters",
        ),
        barrierDismissible: true,
      );
      return;
    }

    if (event.password != event.confirmPassword) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Passwords do not match.\nPlease try again.",
        ),
        barrierDismissible: true,
      );
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      final body = {
        "fullName": event.fullName,
        "email": event.email,
        "password": event.password,
      };

      final response = await _authRepository.registerUser(body);

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        showCommonDialog(
          context: event.context,
          child: otpDialog(event.context, email: event.email),
          barrierDismissible: false,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? "Account not created.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _verifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if (event.otp.length < 4) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(
          event.context,
          "Please enter the 4-digit\nverification code",
        ),
        barrierDismissible: true,
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.verifyOtp({
        "email": event.email,
        "otp": int.parse(event.otp),
      });

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final accessToken = response['accessToken'];
        if (accessToken != null && accessToken.toString().isNotEmpty) {
          await StorageService.setToken(accessToken.toString());
        }
        Navigator.pop(event.context);
        showCommonDialog(
          context: event.context,
          child: accountVerifiedDialog(event.context),
          barrierDismissible: false,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['message'] ??
                response['error'] ??
                "Invalid OTP. Please try again.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _resendOtp(
    ResendOtpEvent event,
    Emitter<AuthStates> emit,
  ) async {
    try {
      emit(state.copyWith(isResendOTP: true));
      final response = await _authRepository.resendOtp({"email": event.email});

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        FlushBarHelper.flushBarSuccessMessage(
          response['message'].toString(),
          event.context,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['message'] ??
                response['error'] ??
                "Failed to resend code. Try again.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isResendOTP: false));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthStates> emit) async {
    if (event.email.trim().isEmpty ||
        !RegExp(
          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(event.email.trim())) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter a\nvalid email"),
        barrierDismissible: true,
      );
      return;
    }

    if (event.password.isEmpty) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, "Please enter your\npassword"),
        barrierDismissible: true,
      );
      return;
    }
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.login({
        "email": event.email.trim(),
        "password": event.password,
      });

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final accessToken = response['accessToken'];
        if (accessToken != null && accessToken.toString().isNotEmpty) {
          await StorageService.setToken(accessToken.toString());
        }
        Navigator.pushNamedAndRemoveUntil(
          event.context,
          AppRoutes.whoAreYou,
          (route) => false,
        );
      } else {
        showCommonDialog(
          context: event.context,
          child: errorDialog(
            event.context,
            response['error'] ?? response['message'] ?? "Login failed.",
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      showCommonDialog(
        context: event.context,
        child: errorDialog(event.context, e.toString()),
        barrierDismissible: true,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
