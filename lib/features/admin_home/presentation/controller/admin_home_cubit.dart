import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_tracker/features/admin_home/data/repo/admin_home_repo.dart';
import 'package:sales_tracker/features/admin_home/presentation/controller/admin_home_states.dart';

class AdminHomeCubit extends Cubit<AdminHomeStates> {
  AdminHomeCubit(this._repo) : super(AdminHomeInitial());

  final AdminHomeRepo _repo;

  Future<void> fetchAdminHome() async {
    emit(AdminHomeLoading());

    final result = await _repo.getAdminDashboard();

    result.fold(
      (failure) => emit(AdminHomeFailed(failure.errMessage)),
      (dashboard) => emit(AdminHomeSuccess(dashboard)),
    );
  }
}
