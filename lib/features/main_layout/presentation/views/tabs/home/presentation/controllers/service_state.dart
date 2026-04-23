part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();
  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  const ServiceLoaded({required this.services});
  final List<Service> services;

  @override
  List<Object> get props => [services];
}

class ServiceError extends ServiceState {
  const ServiceError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class SendRequestLoading extends ServiceState {}

class SendRequestSuccess extends ServiceState {
  const SendRequestSuccess({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

class SendRequestError extends ServiceState {
  const SendRequestError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
