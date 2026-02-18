import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/data/repo/client_repo.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit(this.repo) : super(ClientInitial());
  final ClientRepo repo;

  Future<void> getClients() async {
    try {
      emit(ClientLoading());

      final clients = await repo.getClients();
      emit(ClientSuccess(clients));
    } catch (e) {
      emit(ClientFailed(e.toString()));
    }
  }

  Future<void> addClient(ClientModel client) async {
    try {
      await repo.addClient(client);
      await getClients();
    } catch (e) {
      emit(ClientFailed(e.toString()));
    }
  }
}
