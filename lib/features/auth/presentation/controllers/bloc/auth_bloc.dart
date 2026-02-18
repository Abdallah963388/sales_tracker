import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/../features/auth/data/model/user_model.dart';
import '/../features/auth/data/repo/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepo) : super(AuthInitial()) {
    // Login
    on<LoginReqEvent>((event, emit) async {
      emit(LoginLoadingState());
      final result = await _authRepo.login(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (l) => emit(
          LoginFailedState(l.toString()),
        ),
        (model) {
          userModel = model;
          emit(LoginSuccessState(model));
        },
      );
    });

    // Register
    on<RegisterReqEvent>((event, emit) async {
      emit(RegisterLoadingState());
      final result = await _authRepo.register(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      result.fold(
        (l) => emit(RegisterFailedState(l.toString())),
        (model) {
          userModel = model;
          emit(RegisterSuccessState(model));
        },
      );
    });

    // Forgot Password
    on<ForgotPasswordReqEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      final result = await _authRepo.forgotPassword(email: event.email);
      result.fold(
        (l) => emit(ForgotPasswordFailedState(l.toString())),
        (responseCode) {
          code = responseCode;
          emit(ForgotPasswordSuccessState(responseCode));
        },
      );
    });

    // Verify Code
    on<VerifyCodeReqEvent>((event, emit) async {
      emit(VerifyCodeLoadingState());
      final result = await _authRepo.verifyCode(
        code: event.code,
        email: event.email,
      );
      result.fold(
        (l) => emit(VerifyCodeFailedState(l.toString())),
        (success) => emit(VerifyCodeSuccessState()),
      );
    });

    // Reset Password
    on<ResetPasswordReqEvent>((event, emit) async {
      emit(ResetPasswordLoadingState());
      final result = await _authRepo.resetPassword(
        password: event.password,
        confirmPassword: event.confirmPassword,
        email: event.email,
      );
      result.fold(
        (l) => emit(ResetPasswordFailedState(l.toString())),
        (success) => emit(ResetPasswordSuccessState()),
      );
    });

    // Logout
    on<LogoutReqEvent>((event, emit) async {
      emit(LogoutLoadingState());
      final result = await _authRepo.logout();
      result.fold(
        (l) => emit(LogoutFailedState(l.toString())),
        (success) {
          userModel = null;
          emit(LogoutSuccessState());
        },
      );
    });

    // Toggle Password Visibility
    on<TogglePasswordVisibilityEvent>((event, emit) {
      isPasswordHidden = !isPasswordHidden;
      emit(PasswordVisibilityChangedState(isPasswordHidden));
    });

    // Toggle Confirm Password Visibility
    on<ToggleConfirmPasswordVisibilityEvent>((event, emit) {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
      emit(ConfirmPasswordVisibilityChangedState(isConfirmPasswordHidden));
    });

    // Set Verify Code
    on<SetVerifyCodeEvent>((event, emit) {
      enteredCode = event.code;
      emit(SetVerifyCodeState(event.code));
    });

    // Countdown Timer
    on<StartCountdownEvent>((event, emit) async {
      _timer?.cancel();
      _seconds = 120;
      emit(CountdownRunning(_seconds));

      // Using Stream for timer in Bloc
      await emit.forEach<int>(
        Stream.periodic(
          const Duration(seconds: 1),
          (x) => _seconds - x - 1,
        ).take(120),
        onData: (value) {
          _seconds = value;
          if (value == 0) return CountdownFinished();
          return CountdownRunning(value);
        },
      );
    });

    on<ResetCountdownEvent>((event, emit) {
      _timer?.cancel();
      _seconds = 120;
      emit(CountdownInitial(_seconds));
    });
  }
  final AuthRepo _authRepo;

  UserModel? userModel;
  String? code;
  String? enteredCode;

  // UI Variables
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  Timer? _timer;
  int _seconds = 120;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
