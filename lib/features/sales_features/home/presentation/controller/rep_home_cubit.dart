import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sit/features/sales_features/home/data/model/rep_home_model.dart';
import 'package:sit/features/sales_features/home/data/repo/rep_home_repo.dart';


part 'rep_home_states.dart'; // ربط الـ part هنا

class RepHomeCubit extends Cubit<RepHomeState> {
  RepHomeCubit(this._repo) : super(RepHomeInitial());

  final RepHomeRepo _repo;

  Future<void> fetchRepHome() async {
    emit(RepHomeLoading());

    final result = await _repo.getDashboard();

    result.fold(
      (failure) => emit(RepHomeFailed(failure.errMessage)),
      (dashboard) => emit(RepHomeSuccess(dashboard)),
    );
  }
}
