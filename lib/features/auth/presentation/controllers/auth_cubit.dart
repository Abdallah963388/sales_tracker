import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sit/features/auth/data/model/user_model.dart';

import '../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class LoginCubit extends Cubit<AuthState> {
  LoginCubit(this._authRepo) : super(AuthInitial());

  final AuthRepo _authRepo;
  bool isPasswordHidden = true;

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(PasswordVisibilityChangedState());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    final result = await _authRepo.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(LoginFailedState(failure.errMessage));
      },
      (userModel) {
        emit(LoginSuccessState(userModel));
      },
    );
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());

    final result = await _authRepo.logout();

    result.fold(
      (failure) => emit(LogoutFailedState(failure.errMessage)),
      (_) => emit(LogoutSuccessState()),
    );
  }
}
