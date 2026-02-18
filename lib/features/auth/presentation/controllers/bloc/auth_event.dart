part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginReqEvent extends AuthEvent {
  LoginReqEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class RegisterReqEvent extends AuthEvent {
  RegisterReqEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
}

class ForgotPasswordReqEvent extends AuthEvent {
  ForgotPasswordReqEvent({required this.email});
  final String email;
}

class VerifyCodeReqEvent extends AuthEvent {
  VerifyCodeReqEvent({required this.code, required this.email});
  final String code;
  final String email;
}

class ResetPasswordReqEvent extends AuthEvent {
  ResetPasswordReqEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  final String email;
  final String password;
  final String confirmPassword;
}

class LogoutReqEvent extends AuthEvent {}

// Events for UI Logic (Visibility & Timer)
class TogglePasswordVisibilityEvent extends AuthEvent {}

class ToggleConfirmPasswordVisibilityEvent extends AuthEvent {}

class StartCountdownEvent extends AuthEvent {}

class ResetCountdownEvent extends AuthEvent {}

class SetVerifyCodeEvent extends AuthEvent {
  SetVerifyCodeEvent(this.code);
  final String code;
}
