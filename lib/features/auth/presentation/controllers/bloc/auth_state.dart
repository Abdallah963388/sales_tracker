// ignore_for_file: avoid_positional_boolean_parameters

part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login States
class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  LoginSuccessState(this.userModel);
  final UserModel userModel;
}

class LoginFailedState extends AuthState {
  LoginFailedState(this.error);
  final String error;
}

// Register States
class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {
  RegisterSuccessState(this.userModel);
  final UserModel userModel;
}

class RegisterFailedState extends AuthState {
  RegisterFailedState(this.error);
  final String error;
}

// Forgot Password States
class ForgotPasswordLoadingState extends AuthState {}

class ForgotPasswordSuccessState extends AuthState {
  ForgotPasswordSuccessState(this.code);
  final String? code;
}

class ForgotPasswordFailedState extends AuthState {
  ForgotPasswordFailedState(this.error);
  final String error;
}

// Verify Code States
class VerifyCodeLoadingState extends AuthState {}

class VerifyCodeSuccessState extends AuthState {}

class VerifyCodeFailedState extends AuthState {
  VerifyCodeFailedState(this.error);
  final String error;
}

// Reset Password States
class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordFailedState extends AuthState {
  ResetPasswordFailedState(this.error);
  final String error;
}

// Logout States
class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutFailedState extends AuthState {
  LogoutFailedState(this.error);
  final String error;
}

// UI States
class PasswordVisibilityChangedState extends AuthState {
  PasswordVisibilityChangedState(this.isPasswordHidden);
  final bool isPasswordHidden;
}

class ConfirmPasswordVisibilityChangedState extends AuthState {
  ConfirmPasswordVisibilityChangedState(this.isConfirmPasswordHidden);
  final bool isConfirmPasswordHidden;
}

class SetVerifyCodeState extends AuthState {
  SetVerifyCodeState(this.code);
  final String code;
}

class CountdownInitial extends AuthState {
  CountdownInitial(this.seconds);
  final int seconds;
}

class CountdownRunning extends AuthState {
  CountdownRunning(this.seconds);
  final int seconds;
}

class CountdownFinished extends AuthState {}
