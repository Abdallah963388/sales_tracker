import 'package:sales_tracker/features/clients/data/model/client_model.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientSuccess extends ClientState {
  ClientSuccess(this.clients);
  final List<ClientModel> clients;
}

class ClientFailed extends ClientState {
  ClientFailed(this.message);
  final String message;
}
