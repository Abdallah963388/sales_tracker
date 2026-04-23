part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
  @override
  List<Object> get props => [];
}

class FetchServicesEvent extends ServiceEvent {
  const FetchServicesEvent();
}

class SendRequestServiceEvent extends ServiceEvent {
  const SendRequestServiceEvent({required this.requestModel});
  final RequestServiceModel requestModel;

  @override
  List<Object> get props => [requestModel];
}
