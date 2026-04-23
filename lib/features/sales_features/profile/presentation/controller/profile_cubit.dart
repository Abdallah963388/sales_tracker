import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sit/core/services/loading.dart';
import 'package:sit/features/sales_features/profile/data/model/profile_model.dart';
import 'package:sit/features/sales_features/profile/data/repo/profile_repo.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_states.dart';


class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repo) : super(ProfileInitial());

  final ProfileRepo repo;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  UserProfileData? profile;

  Future<void> getProfile() async {
    emit(ProfileLoading());
    showLoading();

    final result = await repo.getProfile();

    result.fold(
      (failure) {
        hideLoading();
        emit(ProfileFailed(failure.errMessage));
      },
      (data) {
        hideLoading();
        profile = data;
        print(profile?.name);

        nameController.text = data.name ?? '';
        emailController.text = data.email ?? '';
        phoneController.text = data.phone ?? '';

        emit(ProfileSuccess());
      },
    );
  }

  Future<void> updateProfile() async {
    emit(ProfileUpdateLoading());
    showLoading();

    final result = await repo.updateProfile(
      data: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      },
    );

    result.fold(
      (failure) {
        hideLoading();
        emit(ProfileUpdateFailed(failure.errMessage));
      },
      (message) async {
        hideLoading();
        await getProfile();
        emit(ProfileUpdateSuccess(message));
      },
    );
  }
}
