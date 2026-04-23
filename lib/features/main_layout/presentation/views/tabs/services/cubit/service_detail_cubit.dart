import 'package:equatable/equatable.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/domain/repository/service_repository.dart';
import 'package:sit/features/my_app/controller/safe_cubit.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends SafeCubit<ServiceDetailState> {
  ServiceDetailCubit({required this.repository})
    : super(ServiceDetailInitial());
  final ServiceRepository repository;

  Future<void> fetchServiceDetail(int id) async {
    emit(ServiceDetailLoading());
    try {
      final service = await repository.getServiceDetail(id);
      emit(ServiceDetailLoaded(service: service));
    } catch (e) {
      emit(ServiceDetailError(message: 'Failed to load service detail: $e'));
    }
  }
}
