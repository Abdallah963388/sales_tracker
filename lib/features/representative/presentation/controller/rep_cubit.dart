import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_tracker/core/services/loading.dart';
import 'package:sales_tracker/features/representative/data/model/single_rep_model.dart';
import 'package:sales_tracker/features/representative/data/repo/rep_repo.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_states.dart';

class RepCubit extends Cubit<RepState> {
  RepCubit(this._repo) : super(const RepState());
  final RepRepo _repo;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  Future<void> getReps() async {
    try {
      emit(state.copyWith(status: RepStatus.loading));

      final response = await _repo.getReps();

      emit(state.copyWith(status: RepStatus.success, reps: response));
    } catch (e) {
      emit(state.copyWith(status: RepStatus.failure, error: e.toString()));
    }
  }

  Future<void> addRep() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      emit(state.copyWith(error: 'يرجى ملء جميع البيانات المطلوبة'));
      return;
    }

    try {
      emit(state.copyWith(status: RepStatus.addLoading));
      showLoading();

      final result = await _repo.addRep(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      );

      result.fold(
        (failure) {
          hideLoading();
          emit(
            state.copyWith(
              status: RepStatus.failure,
              error: failure.errMessage,
            ),
          );
        },
        (message) async {
          hideLoading();
          await getReps();
          resetForm();
          emit(state.copyWith(status: RepStatus.addSuccess, message: message));
        },
      );
    } catch (e) {
      hideLoading();
      emit(state.copyWith(status: RepStatus.failure, error: e.toString()));
    }
  }

  Future<void> getSingleRep(int repId) async {
    try {
      emit(state.copyWith(status: RepStatus.singleLoading));
      showLoading();

      final result = await _repo.getSingleRep(repId);

      result.fold(
        (failure) {
          hideLoading();
          emit(
            state.copyWith(
              status: RepStatus.failure,
              error: failure.errMessage,
            ),
          );
        },
        (rep) {
          hideLoading();
          emit(state.copyWith(status: RepStatus.singleSuccess, singleRep: rep));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: RepStatus.failure, error: e.toString()));
    }
  }

  Future<void> deleteRep(int repId) async {
    emit(state.copyWith(status: RepStatus.deleteLoading));

    final result = await _repo.deleteRep(repId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: RepStatus.failure, error: failure.errMessage),
      ),
      (message) async {
        await getReps();
        emit(state.copyWith(status: RepStatus.deleteSuccess, message: message));
      },
    );
  }

  Future<void> updateRep(int repId) async {
    emit(state.copyWith(status: RepStatus.updateLoading));
    showLoading();

    final result = await _repo.updateRep(
      repId: repId,
      data: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text,
      },
    );

    result.fold(
      (failure) {
        hideLoading();
        emit(
          state.copyWith(status: RepStatus.failure, error: failure.errMessage),
        );
      },
      (message) async {
        hideLoading();
        final client = (await getSingleRep(repId)) as SingleRepData?;
        final response = await _repo.getReps();
        emit(
          state.copyWith(
            message: message,
            singleRep: client,
            reps: response,
            status: RepStatus.updateSuccess,
          ),
        );
      },
    );
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
  }
  
}
