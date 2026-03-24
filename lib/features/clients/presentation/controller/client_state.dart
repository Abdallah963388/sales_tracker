import 'package:equatable/equatable.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

enum ClientStatus {
  initial,
  loading,
  success,
  failure,
  addLoading,
  addSuccess,
  deleteLoading,
  deleteSuccess,
  updateLoading,
  updateSuccess,
}

class ClientState extends Equatable {
  const ClientState({
    this.status = ClientStatus.initial,
    this.clients,
    this.allClients,
    this.singleClient,
    this.message,
    this.error,
  });
  final ClientStatus status;
  final List<ClientsResponse>? clients;
  final List<ClientsResponse>? allClients;
  final Client? singleClient;
  final String? message;
  final String? error;

  ClientState copyWith({
    ClientStatus? status,
    List<ClientsResponse>? clients,
    List<ClientsResponse>? allClients,
    Client? singleClient,
    String? message,
    String? error,
  }) {
    return ClientState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      allClients: allClients ?? this.allClients,
      singleClient: singleClient ?? this.singleClient,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    clients,
    allClients,
    singleClient,
    message,
    error,
  ];
}
