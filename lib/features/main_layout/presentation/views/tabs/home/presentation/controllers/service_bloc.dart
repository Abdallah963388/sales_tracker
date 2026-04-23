import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sit/core/networking/failures.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/request_service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/domain/repository/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc({required this.repository}) : super(ServiceInitial()) {
    on<FetchServicesEvent>(_onFetchServices);
    on<SendRequestServiceEvent>(_onSendRequestService);
  }
  final ServiceRepository repository;

  Future<void> _onFetchServices(
    FetchServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      final services = await repository.getServices();
      emit(ServiceLoaded(services: services));
    } on ServerFailure catch (failure) {
      emit(ServiceError(message: failure.errMessage));
    }
  }

  Future<void> _onSendRequestService(
    SendRequestServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(SendRequestLoading());
    try {
      final message = await repository.sendRequestService(event.requestModel);
      emit(SendRequestSuccess(message: message));
    } on ServerFailure catch (failure) {
      emit(ServiceError(message: failure.errMessage));
    }
  }
}
