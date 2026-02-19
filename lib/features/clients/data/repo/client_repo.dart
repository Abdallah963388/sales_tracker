import 'package:sales_tracker/features/clients/data/data_source/remote_data_source.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class ClientRepo {
  ClientRepo(this.remoteDataSource);
  final RemoteDataSource remoteDataSource;

  Future<List<ClientModel>> getClients() {
    return remoteDataSource.getClients();
  }

  Future<void> addClient(ClientModel clients) {
    return remoteDataSource.addClient(clients);
  }
}
