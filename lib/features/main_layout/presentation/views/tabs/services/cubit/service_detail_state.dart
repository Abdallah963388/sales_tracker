part of 'service_detail_cubit.dart';

abstract class ServiceDetailState extends Equatable {
  const ServiceDetailState();
  @override
  List<Object> get props => [];
}

class ServiceDetailInitial extends ServiceDetailState {}

class ServiceDetailLoading extends ServiceDetailState {}

class ServiceDetailLoaded extends ServiceDetailState {
  const ServiceDetailLoaded({required this.service});
  final Service service;

  @override
  List<Object> get props => [service];
}

class ServiceDetailError extends ServiceDetailState {
  const ServiceDetailError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
