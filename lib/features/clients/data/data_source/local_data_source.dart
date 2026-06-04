

import 'package:hive/hive.dart';
import 'package:sit/features/clients/data/model/client_model.dart';

class LocalDataSource {
  static const boxName = 'clientsBox';

  Future<List<Client>> getClients() async{

    final box = await Hive.openBox<Client>(boxName);
    return box.values.toList();

  }
   
   Future<void> addClient(Client client) async{
    final box = await Hive.openBox<Client>(boxName);
    await box.add(client);

   }

}