import 'package:dio/dio.dart';
import 'package:sales_tracker/core/networking/end_points.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class RemoteDataSource {
  RemoteDataSource(this.dio);
  final Dio dio;

  Future<List<ClientModel>> getClients() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.home);

    return (response.data as List)
        .map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addClient(ClientModel client) async {
    // ignore: inference_failure_on_function_invocation
    await dio.post(
      EndPoints.home,
      data: client.toJson(),
    );
  }
}
